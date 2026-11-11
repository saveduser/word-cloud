from std.testing import assert_true, assert_false, assert_equal, TestSuite
from std.collections import List
from wordcloud.types import Rect, WordFrequency, PlacedWord
from wordcloud.config import WordCloudConfig
from wordcloud.layout import WordCloudLayout, PseudoRandom

def test_prng_determinism() raises:
    var p1 = PseudoRandom(42)
    var p2 = PseudoRandom(42)
    for _ in range(20):
        assert_equal(p1.next_float(), p2.next_float())

def test_single_word_placement() raises:
    var config = WordCloudConfig(width=600, height=400, random_seed=42)
    var layout = WordCloudLayout(config)

    var freqs = List[WordFrequency]()
    freqs.append(WordFrequency("mojo", 100))

    var colors = List[String]()
    colors.append("#ff0000")

    var placed = layout.place(freqs, colors)
    assert_equal(len(placed), 1)

    var w = placed[0].copy()
    assert_equal(w.word, "mojo")
    # Should be close to center (300, 200)
    var center_x = w.x + w.width / 2.0
    var center_y = w.y + w.height / 2.0
    assert_true(center_x > 250.0 and center_x < 350.0)
    assert_true(center_y > 150.0 and center_y < 250.0)

def test_no_overlap_between_words() raises:
    var config = WordCloudConfig(
        width=800,
        height=600,
        min_font_size=12.0,
        max_font_size=50.0,
        padding=4.0,
        random_seed=100,
    )
    var layout = WordCloudLayout(config)

    var freqs = List[WordFrequency]()
    freqs.append(WordFrequency("performance", 100))
    freqs.append(WordFrequency("compiler", 80))
    freqs.append(WordFrequency("speed", 70))
    freqs.append(WordFrequency("memory", 60))
    freqs.append(WordFrequency("safety", 50))
    freqs.append(WordFrequency("native", 40))
    freqs.append(WordFrequency("simd", 30))
    freqs.append(WordFrequency("types", 20))

    var colors = List[String]()
    colors.append("#1f77b4")
    colors.append("#ff7f0e")

    var placed = layout.place(freqs, colors)
    assert_true(len(placed) >= 5)

    var canvas = Rect(0.0, 0.0, 800.0, 600.0)

    # Check pairwise non-overlapping and boundary containment
    for i in range(len(placed)):
        var r_i = placed[i].bounds()
        assert_true(canvas.contains(r_i))

        for j in range(i + 1, len(placed)):
            var r_j = placed[j].bounds()
            assert_false(r_i.intersects(r_j, padding=config.padding - 0.01))

def test_layout_reproducibility() raises:
    var config1 = WordCloudConfig(random_seed=777)
    var config2 = WordCloudConfig(random_seed=777)

    var freqs = List[WordFrequency]()
    freqs.append(WordFrequency("alpha", 50))
    freqs.append(WordFrequency("beta", 30))
    freqs.append(WordFrequency("gamma", 20))

    var colors = List[String]()
    colors.append("#333333")

    var placed1 = WordCloudLayout(config1).place(freqs, colors)
    var placed2 = WordCloudLayout(config2).place(freqs, colors)

    assert_equal(len(placed1), len(placed2))
    for i in range(len(placed1)):
        assert_equal(placed1[i].word, placed2[i].word)
        assert_equal(placed1[i].x, placed2[i].x)
        assert_equal(placed1[i].y, placed2[i].y)
        assert_equal(placed1[i].is_vertical, placed2[i].is_vertical)

def test_high_density_placement() raises:
    var config = WordCloudConfig(
        width=1000,
        height=700,
        min_font_size=12.0,
        max_font_size=65.0,
        padding=3.0,
        random_seed=42,
    )
    var layout = WordCloudLayout(config)

    var words = (
        "mojo performance compiler acceleration vectorization optimization "
        "concurrency distributed tensor hardware efficiency modularity "
        "architecture scalability robustness throughput parallelism "
        "instruction pipeline execution algorithm memory safety typing"
    )
    var parts = words.split(" ")
    var freqs = List[WordFrequency]()
    for i in range(len(parts)):
        freqs.append(WordFrequency(String(parts[i]), (len(parts) - i) * 5 + 10))

    var colors = List[String]()
    colors.append("#4E79A7")
    colors.append("#F28E2B")
    colors.append("#E15759")

    var placed = layout.place(freqs, colors)
    # High placement success rate (> 90%)
    assert_true(len(placed) >= 23)

    var canvas = Rect(0.0, 0.0, 1000.0, 700.0)
    for i in range(len(placed)):
        var r_i = placed[i].bounds()
        assert_true(canvas.contains(r_i))
        for j in range(i + 1, len(placed)):
            var r_j = placed[j].bounds()
            assert_false(r_i.intersects(r_j, padding=config.padding - 0.01))

def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
