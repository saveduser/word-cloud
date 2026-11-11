from std.collections import List
from std.math import sqrt, log
from wordcloud.types import WordFrequency

@fieldwise_init
struct WordDimensions(Copyable, Movable):
    """Represents calculated width and height dimensions for rendered text."""
    var width: Float64
    var height: Float64

def estimate_glyph_width_factor(cp: Int, font_family: String = "sans-serif") -> Float64:
    """Estimates the relative width of a character relative to font size (em)."""
    if font_family == "monospace":
        return 0.60

    # Very narrow characters (factor ~ 0.28)
    # i, l, I, !, ., ,, ;, :, ', |, `, 1
    if (
        cp == 105 or cp == 108 or cp == 73 or cp == 33 or cp == 46 or cp == 44
        or cp == 59 or cp == 58 or cp == 39 or cp == 124 or cp == 96 or cp == 49
    ):
        return 0.28

    # Narrow characters (factor ~ 0.38)
    # r, t, f, j, (, ), [, ], {, }, -, /
    if (
        cp == 114 or cp == 116 or cp == 102 or cp == 106 or cp == 40 or cp == 41
        or cp == 91 or cp == 93 or cp == 123 or cp == 125 or cp == 45 or cp == 47
        or cp == 32
    ):
        return 0.38

    # Very wide characters (factor ~ 0.85)
    # m, w, M, W, @, %, &, ~
    if (
        cp == 109 or cp == 119 or cp == 77 or cp == 87 or cp == 64 or cp == 37
        or cp == 38 or cp == 126
    ):
        return 0.85

    # Capital letters (factor ~ 0.65)
    # A-Z (excluding I, M, W handled above)
    if cp >= 65 and cp <= 90:
        return 0.65

    # Standard lowercase and numbers (factor ~ 0.52)
    return 0.52

def estimate_word_dimensions(
    word: String,
    font_size: Float64,
    font_family: String = "sans-serif",
) -> WordDimensions:
    """Calculates estimated rendered bounding box width and height for a word."""
    var total_width_factor: Float64 = 0.0

    for cp in word.codepoints():
        total_width_factor += estimate_glyph_width_factor(Int(cp), font_family)

    var width = total_width_factor * font_size
    var height = font_size * 0.90
    return WordDimensions(width, height)

def calculate_font_sizes(
    frequencies: List[WordFrequency],
    min_font_size: Float64,
    max_font_size: Float64,
    scaling: String = "sqrt",
) -> List[Float64]:
    """Computes proportionally scaled font sizes for each word frequency entry."""
    var sizes = List[Float64]()
    var n = len(frequencies)
    if n == 0:
        return sizes^

    if n == 1 or frequencies[0].frequency == frequencies[n - 1].frequency:
        # All words have same frequency
        for _ in range(n):
            sizes.append(max_font_size)
        return sizes^

    var max_f = Float64(frequencies[0].frequency)
    var min_f = Float64(frequencies[n - 1].frequency)
    var font_range = max_font_size - min_font_size

    for i in range(n):
        var f = Float64(frequencies[i].frequency)
        var norm_ratio: Float64

        if scaling == "linear":
            norm_ratio = (f - min_f) / (max_f - min_f)
        elif scaling == "log":
            norm_ratio = (log(f + 1.0) - log(min_f + 1.0)) / (log(max_f + 1.0) - log(min_f + 1.0))
        else:
            # Default "sqrt" scaling: balanced power scaling
            norm_ratio = (sqrt(f) - sqrt(min_f)) / (sqrt(max_f) - sqrt(min_f))

        var size = min_font_size + font_range * norm_ratio
        sizes.append(size)

    return sizes^
