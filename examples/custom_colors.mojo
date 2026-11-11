from wordcloud import WordCloud, Palette
from std.collections import List

def main() raises:
    print("Generating custom colors word cloud...")

    var cloud = WordCloud(
        width=1200,
        height=800,
        background_color="#0f172a", # Deep navy background
        min_font_size=14.0,
        max_font_size=90.0,
        font_family="sans-serif",
        padding=4.0,
        random_seed=123,
    )

    # Use a vibrant cyberpunk/neon palette
    var neon_colors = List[String]()
    neon_colors.append("#06b6d4") # Cyan
    neon_colors.append("#3b82f6") # Blue
    neon_colors.append("#8b5cf6") # Purple
    neon_colors.append("#ec4899") # Pink
    neon_colors.append("#f43f5e") # Rose
    neon_colors.append("#10b981") # Emerald
    neon_colors.append("#f59e0b") # Amber

    cloud.set_palette(Palette.custom(neon_colors))

    var text = """
        Distributed systems, GPU acceleration, neural networks, deep learning models,
        parallel computing, concurrency, tensor cores, vectorization, kernel fusion,
        performance engineering, real-time telemetry, asynchronous workflows, microservices,
        high-throughput streaming, low latency architectures, cache optimization, memory hierarchy.
    """

    var result = cloud.generate(text)

    print("Successfully placed words:", result.word_count())
    result.save_svg("output_custom_colors.svg")
    print("Saved word cloud SVG to output_custom_colors.svg")
