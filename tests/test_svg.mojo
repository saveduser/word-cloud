from std.testing import assert_true, assert_equal, TestSuite
from std.collections import List
from wordcloud.types import PlacedWord
from wordcloud.exporters.svg import escape_xml, export_svg, save_svg

def test_xml_escaping() raises:
    var raw = "M&M's <tag> \"quote\""
    var escaped = escape_xml(raw)
    assert_equal(escaped, "M&amp;M&apos;s &lt;tag&gt; &quot;quote&quot;")

def test_svg_document_structure() raises:
    var words = List[PlacedWord]()
    words.append(PlacedWord("mojo", 100, 48.0, 100.0, 100.0, 120.0, 40.0, False, "#FF0000"))
    words.append(PlacedWord("fast", 80, 32.0, 250.0, 150.0, 30.0, 80.0, True, "#00FF00"))

    var svg = export_svg(words, 800, 600, background_color="#111111", font_family="monospace")

    assert_true(svg.byte_length() > 0)
    assert_true("<?xml version=\"1.0\"" in svg)
    assert_true("<svg " in svg)
    assert_true('width="800"' in svg)
    assert_true('height="600"' in svg)
    assert_true('fill="#111111"' in svg)
    assert_true('font-family="monospace"' in svg)
    assert_true(">mojo</text>" in svg)
    assert_true(">fast</text>" in svg)
    assert_true('transform="rotate(90' in svg)

def test_save_svg_file() raises:
    var words = List[PlacedWord]()
    words.append(PlacedWord("test", 50, 24.0, 50.0, 50.0, 60.0, 20.0, False, "#000000"))

    var svg = export_svg(words, 400, 300)
    var test_path = "/tmp/test_wordcloud_out.svg"
    save_svg(svg, test_path)

    with open(test_path, "r") as f:
        var content = f.read()
        assert_true("<?xml version=\"1.0\"" in content)
        assert_true(">test</text>" in content)

def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
