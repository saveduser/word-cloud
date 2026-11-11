from wordcloud import WordCloud, Palette
from std.collections import Dict

def main() raises:
    print("Generating word cloud from precomputed frequencies...")

    var cloud = WordCloud(
        width=1100,
        height=700,
        background_color="#18181b", # Dark zinc
        min_font_size=14.0,
        max_font_size=85.0,
        font_family="monospace",
        padding=4.0,
        random_seed=314,
    )

    cloud.set_palette(Palette.viridis())

    var freqs = Dict[String, Int]()
    freqs["Mojo"] = 150
    freqs["Python"] = 110
    freqs["Rust"] = 95
    freqs["C++"] = 90
    freqs["Go"] = 75
    freqs["TypeScript"] = 70
    freqs["Swift"] = 60
    freqs["Kotlin"] = 55
    freqs["Java"] = 50
    freqs["C#"] = 45
    freqs["Julia"] = 40
    freqs["Haskell"] = 35
    freqs["Zig"] = 35
    freqs["Elixir"] = 30
    freqs["Lua"] = 25
    freqs["Ruby"] = 20

    var result = cloud.generate_from_frequencies(freqs)

    print("Successfully placed words:", result.word_count())
    result.save_svg("output_frequencies.svg")
    print("Saved word cloud SVG to output_frequencies.svg")
