from wordcloud import WordCloud, create_stopwords
from std.collections import List

def main() raises:
    print("Generating word cloud with custom stopwords...")

    var cloud = WordCloud(
        width=900,
        height=650,
        background_color="#f8fafc",
        min_font_size=12.0,
        max_font_size=75.0,
        padding=3.0,
        random_seed=88,
    )

    # Filter out common generic coding words alongside standard English stopwords
    var domain_stopwords = List[String]()
    domain_stopwords.append("code")
    domain_stopwords.append("coding")
    domain_stopwords.append("program")
    domain_stopwords.append("file")
    domain_stopwords.append("function")
    domain_stopwords.append("software")
    domain_stopwords.append("developer")

    var sw = create_stopwords(domain_stopwords, include_default=True)
    cloud.set_stopwords(sw)

    var text = """
        When writing software and code, every developer should structure their program files carefully.
        Architecture, design patterns, modularity, composition, abstraction, resilience,
        algorithms, data structures, correctness, automated testing, benchmarking, profiling,
        scalability, continuous integration, security, maintainability, clean documentation,
        developer experience, robust typing, static analysis, deterministic builds.
    """

    var result = cloud.generate(text)

    print("Successfully placed words:", result.word_count())
    result.save_svg("output_custom_stopwords.svg")
    print("Saved word cloud SVG to output_custom_stopwords.svg")
