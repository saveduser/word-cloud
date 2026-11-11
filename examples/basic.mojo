from wordcloud import WordCloud

def main() raises:
    print("Generating basic word cloud...")

    var cloud = WordCloud(
        width=1000,
        height=700,
        background_color="#ffffff",
        min_font_size=12.0,
        max_font_size=80.0,
        padding=4.0,
        random_seed=42,
    )

    var text = """
        Mojo is a modern systems programming language that synthesizes the developer friendliness
        of Python with the raw execution speed and memory control of C, C++, and Rust.
        Designed for AI hardware acceleration, machine learning compilers, and high-performance
        heterogeneous computing, Mojo delivers strong static typing, compile-time metaprogramming,
        zero-cost abstractions, full ownership semantics, and automatic vectorization with SIMD.
        With pure native libraries, Mojo developers can build scalable data structures, computational
        geometry algorithms, text tokenizers, and spatial indexing engines with extreme speed and elegance.
        Mojo enables developers to write clean, maintainable, and robust systems software.
    """

    var result = cloud.generate(text)

    print("Successfully placed words:", result.word_count())
    result.save_svg("output_basic.svg")
    print("Saved word cloud SVG to output_basic.svg")
