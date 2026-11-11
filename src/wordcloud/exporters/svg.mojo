from std.collections import List
from wordcloud.types import PlacedWord

def escape_xml(text: String) -> String:
    """Escapes XML special characters for safe inclusion in SVG text nodes."""
    var out = String("")
    for cp in text.codepoints():
        var val = Int(cp)
        if val == 38: # &
            out += "&amp;"
        elif val == 60: # <
            out += "&lt;"
        elif val == 62: # >
            out += "&gt;"
        elif val == 34: # "
            out += "&quot;"
        elif val == 39: # '
            out += "&apos;"
        else:
            out += chr(val)
    return out

def export_svg(
    placed_words: List[PlacedWord],
    width: Int,
    height: Int,
    background_color: String = "#ffffff",
    font_family: String = "sans-serif",
) -> String:
    """Serializes placed words into a standalone, compliant SVG 1.1 document string."""
    var svg = String("")
    svg += '<?xml version="1.0" encoding="UTF-8"?>\n'
    svg += '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" '
    svg += 'width="' + String(width) + '" height="' + String(height) + '" '
    svg += 'viewBox="0 0 ' + String(width) + ' ' + String(height) + '">\n'

    # Background rectangle
    svg += '  <rect width="100%" height="100%" fill="' + background_color + '"/>\n'

    # Container group with font defaults
    svg += '  <g font-family="' + escape_xml(font_family) + '" text-anchor="start" dominant-baseline="hanging">\n'

    for i in range(len(placed_words)):
        var pw = placed_words[i].copy()
        var escaped_word = escape_xml(pw.word)

        svg += '    <text '
        svg += 'x="' + String(pw.x) + '" '
        svg += 'y="' + String(pw.y) + '" '
        svg += 'font-size="' + String(pw.font_size) + '" '
        svg += 'fill="' + pw.color + '" '

        if pw.is_vertical:
            # Rotate 90 degrees clockwise around (x, y)
            svg += 'transform="rotate(90, ' + String(pw.x) + ', ' + String(pw.y) + ') translate(0, -' + String(pw.width) + ')" '

        svg += '>' + escaped_word + '</text>\n'

    svg += '  </g>\n'
    svg += '</svg>\n'
    return svg

def save_svg(
    svg_content: String,
    path: String,
) raises:
    """Writes SVG string content to a file at specified path."""
    with open(path, "w") as f:
        f.write(svg_content)
