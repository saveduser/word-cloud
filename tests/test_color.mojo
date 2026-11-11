from std.testing import assert_true, assert_equal, TestSuite
from std.collections import List
from wordcloud.color import Color, Palette, parse_hex_color

def test_hex_parsing() raises:
    var red = parse_hex_color("#FF0000")
    assert_equal(red.r, 255)
    assert_equal(red.g, 0)
    assert_equal(red.b, 0)

    var green = parse_hex_color("00FF00")
    assert_equal(green.r, 0)
    assert_equal(green.g, 255)
    assert_equal(green.b, 0)

    var shorthand = parse_hex_color("#00F")
    assert_equal(shorthand.r, 0)
    assert_equal(shorthand.g, 0)
    assert_equal(shorthand.b, 255)

def test_color_to_hex() raises:
    var c1 = Color(255, 0, 128)
    assert_equal(c1.to_hex(), "#FF0080")

    var c2 = Color(0, 0, 0)
    assert_equal(c2.to_hex(), "#000000")

    var c3 = Color(255, 255, 255)
    assert_equal(c3.to_hex(), "#FFFFFF")

def test_color_interpolation() raises:
    var black = Color(0, 0, 0)
    var white = Color(200, 200, 200)

    var mid = black.interpolate(white, 0.5)
    assert_equal(mid.r, 100)
    assert_equal(mid.g, 100)
    assert_equal(mid.b, 100)

def test_palettes() raises:
    var classic = Palette.classic()
    assert_equal(classic.size(), 10)
    assert_equal(classic.color_at(0), "#4E79A7")

    var viridis = Palette.viridis()
    assert_equal(viridis.size(), 10)

    var mono = Palette.monochrome("#FF0000")
    assert_equal(mono.size(), 5)

    var custom_colors = List[String]()
    custom_colors.append("#112233")
    custom_colors.append("#445566")
    var custom = Palette.custom(custom_colors)
    assert_equal(custom.size(), 2)
    assert_equal(custom.color_at(0), "#112233")
    assert_equal(custom.color_at(2), "#112233") # wraps around

def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
