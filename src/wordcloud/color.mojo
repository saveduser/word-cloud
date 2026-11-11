from std.collections import List
from std.math import min, max

def hex_char_to_val(cp: Int) -> Int:
    """Converts ASCII hex character codepoint to integer value 0..15."""
    if cp >= 48 and cp <= 57: # '0'..'9'
        return cp - 48
    if cp >= 65 and cp <= 70: # 'A'..'F'
        return cp - 55
    if cp >= 97 and cp <= 102: # 'a'..'f'
        return cp - 87
    return 0

def val_to_hex_char(val: Int) -> String:
    """Converts integer 0..15 to hex character string."""
    var v = val
    if v < 0:
        v = 0
    if v > 15:
        v = 15
    var chars = "0123456789ABCDEF"
    return String(chars[byte=v:v+1])

def byte_to_hex(val: Int) -> String:
    """Converts 0..255 byte integer to two-digit hex string."""
    var v = val
    if v < 0:
        v = 0
    if v > 255:
        v = 255
    return val_to_hex_char(v / 16) + val_to_hex_char(v % 16)

@fieldwise_init
struct Color(Copyable, Movable):
    """Represents an sRGB color."""
    var r: Int
    var g: Int
    var b: Int

    def to_hex(self) -> String:
        """Converts this color to uppercase #RRGGBB format."""
        return "#" + byte_to_hex(self.r) + byte_to_hex(self.g) + byte_to_hex(self.b)

    def interpolate(self, other: Color, t: Float64) -> Color:
        """Linearly interpolates between this color and other with t in [0.0, 1.0]."""
        var factor = max(0.0, min(1.0, t))
        var nr = Int(Float64(self.r) + factor * Float64(other.r - self.r))
        var ng = Int(Float64(self.g) + factor * Float64(other.g - self.g))
        var nb = Int(Float64(self.b) + factor * Float64(other.b - self.b))
        return Color(nr, ng, nb)

def parse_hex_color(hex_str: String) -> Color:
    """Parses #RRGGBB, RRGGBB, #RGB, or RGB into Color struct."""
    var cps = List[Int]()
    for cp in hex_str.codepoints():
        var val = Int(cp)
        if val != 35: # skip '#'
            cps.append(val)

    if len(cps) == 6:
        var r = hex_char_to_val(cps[0]) * 16 + hex_char_to_val(cps[1])
        var g = hex_char_to_val(cps[2]) * 16 + hex_char_to_val(cps[3])
        var b = hex_char_to_val(cps[4]) * 16 + hex_char_to_val(cps[5])
        return Color(r, g, b)
    elif len(cps) == 3:
        var r = hex_char_to_val(cps[0]) * 17
        var g = hex_char_to_val(cps[1]) * 17
        var b = hex_char_to_val(cps[2]) * 17
        return Color(r, g, b)

    # Fallback to dark gray
    return Color(50, 50, 50)

struct Palette(Copyable, Movable):
    """Collection of hex color codes for word styling."""
    var colors: List[String]

    def __init__(out self, colors: List[String]):
        self.colors = colors.copy()

    def get_colors(self) -> List[String]:
        return self.colors.copy()

    def size(self) -> Int:
        return len(self.colors)

    def color_at(self, index: Int) -> String:
        if len(self.colors) == 0:
            return "#000000"
        return self.colors[index % len(self.colors)]

    @staticmethod
    def classic() -> Palette:
        """Vibrant multi-color palette (Tableau 10)."""
        var c = List[String]()
        c.append("#4E79A7")
        c.append("#F28E2B")
        c.append("#E15759")
        c.append("#76B7B2")
        c.append("#59A14F")
        c.append("#EDC948")
        c.append("#B07AA1")
        c.append("#FF9DA7")
        c.append("#9C755F")
        c.append("#BAB0AC")
        return Palette(c)

    @staticmethod
    def viridis() -> Palette:
        """Perceptually uniform Viridis colormap."""
        var c = List[String]()
        c.append("#440154")
        c.append("#482878")
        c.append("#3E4A89")
        c.append("#31688E")
        c.append("#26828E")
        c.append("#1F9E89")
        c.append("#35B779")
        c.append("#6DCD59")
        c.append("#B4DE2C")
        c.append("#FDE725")
        return Palette(c)

    @staticmethod
    def cool() -> Palette:
        """Cool oceanic tones (blues, cyans, teals)."""
        var c = List[String]()
        c.append("#1F77B4")
        c.append("#17BECF")
        c.append("#2CA02C")
        c.append("#3B528B")
        c.append("#21908D")
        c.append("#4575B4")
        return Palette(c)

    @staticmethod
    def warm() -> Palette:
        """Warm energetic tones (reds, oranges, ambers)."""
        var c = List[String]()
        c.append("#D62728")
        c.append("#FF7F0E")
        c.append("#E377C2")
        c.append("#E6550D")
        c.append("#FD8D3C")
        c.append("#D73027")
        return Palette(c)

    @staticmethod
    def pastel() -> Palette:
        """Soft pastel tones."""
        var c = List[String]()
        c.append("#AEC7E8")
        c.append("#FFBB78")
        c.append("#98DF8A")
        c.append("#FF9896")
        c.append("#C5B0D5")
        c.append("#C49C94")
        return Palette(c)

    @staticmethod
    def monochrome(base_hex: String) -> Palette:
        """Generates tonal variations from light to dark based on a base color."""
        var base = parse_hex_color(base_hex)
        var white = Color(240, 240, 240)
        var black = Color(20, 20, 20)

        var c = List[String]()
        c.append(white.interpolate(base, 0.50).to_hex())
        c.append(white.interpolate(base, 0.75).to_hex())
        c.append(base.to_hex())
        c.append(base.interpolate(black, 0.35).to_hex())
        c.append(base.interpolate(black, 0.70).to_hex())
        return Palette(c)

    @staticmethod
    def custom(colors: List[String]) -> Palette:
        """User-defined palette of hex strings."""
        return Palette(colors)
