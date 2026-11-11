from std.testing import assert_true, assert_false, assert_equal, TestSuite
from wordcloud.types import Rect, WordFrequency, PlacedWord
from wordcloud.config import WordCloudConfig

def test_default_config() raises:
    var cfg = WordCloudConfig()
    cfg.validate()
    assert_equal(cfg.width, 800)
    assert_equal(cfg.height, 600)
    assert_equal(cfg.min_font_size, 10.0)
    assert_equal(cfg.max_font_size, 80.0)
    assert_equal(cfg.max_words, 200)
    assert_equal(cfg.background_color, "#ffffff")

def test_custom_config() raises:
    var cfg = WordCloudConfig(
        width=1200,
        height=900,
        min_font_size=15.0,
        max_font_size=120.0,
        background_color="#000000",
        max_words=100,
        random_seed=123,
    )
    cfg.validate()
    assert_equal(cfg.width, 1200)
    assert_equal(cfg.height, 900)
    assert_equal(cfg.min_font_size, 15.0)
    assert_equal(cfg.max_font_size, 120.0)
    assert_equal(cfg.background_color, "#000000")
    assert_equal(cfg.max_words, 100)
    assert_equal(cfg.random_seed, 123)

def test_config_invalid_dimensions() raises:
    var caught = False
    try:
        var cfg = WordCloudConfig(width=0)
        cfg.validate()
    except:
        caught = True
    assert_true(caught)

def test_config_invalid_font_sizes() raises:
    var caught = False
    try:
        var cfg = WordCloudConfig(min_font_size=50.0, max_font_size=20.0)
        cfg.validate()
    except:
        caught = True
    assert_true(caught)

def test_config_negative_padding() raises:
    var caught = False
    try:
        var cfg = WordCloudConfig(padding=-1.0)
        cfg.validate()
    except:
        caught = True
    assert_true(caught)

def test_rect_intersection() raises:
    var r1 = Rect(10.0, 10.0, 20.0, 20.0) # [10, 30] x [10, 30]
    var r2 = Rect(25.0, 25.0, 20.0, 20.0) # [25, 45] x [25, 45] - overlaps
    var r3 = Rect(50.0, 50.0, 20.0, 20.0) # [50, 70] x [50, 70] - separate

    assert_true(r1.intersects(r2))
    assert_true(r2.intersects(r1))
    assert_false(r1.intersects(r3))

    # Test padding effect
    var r4 = Rect(35.0, 10.0, 10.0, 20.0) # gap of 5.0 from r1
    assert_false(r1.intersects(r4, padding=0.0))
    assert_true(r1.intersects(r4, padding=6.0))

def test_rect_contains() raises:
    var canvas = Rect(0.0, 0.0, 800.0, 600.0)
    var inside = Rect(50.0, 50.0, 100.0, 50.0)
    var outside_right = Rect(750.0, 50.0, 100.0, 50.0)
    var outside_top = Rect(50.0, -10.0, 100.0, 50.0)

    assert_true(canvas.contains(inside))
    assert_false(canvas.contains(outside_right))
    assert_false(canvas.contains(outside_top))

def test_word_frequency_order() raises:
    from std.collections import List
    var items = List[WordFrequency]()
    items.append(WordFrequency("beta", 10))
    items.append(WordFrequency("alpha", 25))
    items.append(WordFrequency("gamma", 10))
    items.append(WordFrequency("delta", 50))

    sort(items)

    assert_equal(items[0].word, "delta")
    assert_equal(items[0].frequency, 50)

    assert_equal(items[1].word, "alpha")
    assert_equal(items[1].frequency, 25)

    # Tie-breaker alphabetical
    assert_equal(items[2].word, "beta")
    assert_equal(items[2].frequency, 10)

    assert_equal(items[3].word, "gamma")
    assert_equal(items[3].frequency, 10)

def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
