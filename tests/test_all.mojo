from std.testing import assert_true, assert_equal, TestSuite
from std.collections import Dict
from wordcloud import (
    WordCloud,
    WordCloudResult,
    WordCloudConfig,
    Palette,
    get_default_stopwords,
    create_stopwords,
)

def test_end_to_end_text_generation() raises:
    var cloud = WordCloud(
        width=1000,
        height=750,
        background_color="#ffffff",
        max_words=50,
        min_font_size=12.0,
        max_font_size=70.0,
        random_seed=42,
    )

    var text = """
        Mojo is a new programming language designed for high performance and developer flexibility.
        Mojo combines the usability of Python with the speed of C and C++.
        Performance is critical for systems programming, machine learning, and AI workloads.
        Mojo provides strong static typing, ownership and value semantics, and SIMD hardware acceleration.
        Building a pure Mojo word cloud library demonstrates the power and simplicity of the Mojo ecosystem.
    """

    var result = cloud.generate(text)
    assert_true(result.word_count() > 5)

    var svg = result.to_svg()
    assert_true(svg.byte_length() > 0)
    assert_true("<svg " in svg)
    assert_true('width="1000"' in svg)
    assert_true('height="750"' in svg)
    assert_true(">mojo</text>" in svg)

def test_end_to_end_frequencies_generation() raises:
    var cloud = WordCloud(
        width=800,
        height=600,
        background_color="#000000",
        random_seed=123,
    )
    cloud.set_palette(Palette.viridis())

    var freqs = Dict[String, Int]()
    freqs["Mojo"] = 100
    freqs["Performance"] = 80
    freqs["Compiler"] = 65
    freqs["Memory"] = 50
    freqs["Safety"] = 40
    freqs["Types"] = 35
    freqs["Speed"] = 30

    var result = cloud.generate_from_frequencies(freqs)
    assert_equal(result.word_count(), 7)

    var svg = result.to_svg()
    assert_true('fill="#000000"' in svg)
    assert_true(">mojo</text>" in svg)
    assert_true(">performance</text>" in svg)

def test_end_to_end_custom_stopwords() raises:
    var cloud = WordCloud(random_seed=99)
    from std.collections import List
    var extra = List[String]()
    extra.append("language")
    extra.append("programming")
    var sw = create_stopwords(extra, include_default=True)
    cloud.set_stopwords(sw)

    var text = "Mojo is a programming language for programming and language."
    var result = cloud.generate(text)
    # "programming" and "language" are filtered out, only "mojo" remains!
    assert_equal(result.word_count(), 1)
    assert_equal(result.words()[0].word, "mojo")

def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
