from std.time import perf_counter_ns
from std.collections import List, Dict
from wordcloud import (
    WordCloud,
    WordCloudConfig,
    WordCloudLayout,
    tokenize,
    compute_frequencies,
    get_default_stopwords,
    SpatialGridIndex,
    Rect,
    export_svg,
)

def benchmark_tokenization() raises:
    print("\n--- 1. Tokenizer Benchmark ---")
    var paragraph = """The Development of Artificial Intelligence

Artificial Intelligence (AI) has evolved from a speculative concept to a transformative technology impacting various aspects of modern life. This essay explores AI's historical development, key milestones, and future potential, highlighting its significance in shaping technological, economic, and social landscapes.

Historical Evolution of AI

The concept of AI dates back to ancient myths, but formal development began in the mid-20th century. John McCarthy coined the term "artificial intelligence" in 1956 during the Dartmouth Conference, where researchers explored creating machines that could simulate human intelligence. Early AI research focused on symbolic AI or "good old-fashioned AI" (GOFAI), involving programming machines with rules to mimic human decision-making. Alan Turing's theoretical foundations, such as the Turing Test, proposed that a machine could be considered intelligent if it could engage in a conversation indistinguishable from a human's.

Key Milestones in AI Development

1950s-1960s: Early Enthusiasm and Expert Systems

Early AI programs like the Logic Theorist and General Problem Solver demonstrated potential in performing tasks requiring human-like reasoning. The 1970s and 1980s saw the rise of expert systems, such as MYCIN for medical diagnosis, showcasing AI's ability to store and apply knowledge to specific domains.

1980s-1990s: The Rise of Machine Learning

Limitations of rule-based systems led to machine learning, where machines learn from data rather than pre-programmed rules. Neural networks, inspired by the human brain, gained traction, and backpropagation algorithms enabled effective training, leading to breakthroughs in pattern recognition and classification.

2000s: The Big Data Era

The internet and data proliferation transformed AI research. Machine learning algorithms, especially deep learning, began to outperform traditional methods in tasks like image and speech recognition. Companies like Google and Amazon revolutionized search engines, social media, and e-commerce using AI.

2010s: AI in Everyday Life

AI became ubiquitous, with applications in personal assistants like Siri and Alexa, autonomous vehicles, and recommendation systems. Convolutional neural networks (CNNs) and recurrent neural networks (RNNs) enhanced AI's capabilities in processing visual and sequential data.

Current State and Applications of AI

Today, AI encompasses machine learning, natural language processing, robotics, and more, impacting various industries:

Healthcare: AI algorithms assist in diagnosing diseases, predicting patient outcomes, and personalizing treatment plans. Machine learning models analyze medical images with remarkable accuracy, aiding early detection of conditions like cancer.

Finance: AI-driven algorithms analyze market trends, detect fraudulent activities, and optimize investment strategies. Robo-advisors provide personalized financial advice based on individual risk profiles.

Education: AI-powered platforms offer personalized learning experiences, adapting to students' needs and progress. Virtual tutors and intelligent content recommendation systems enhance educational experiences.

Entertainment: AI generates content, recommends music and movies, and creates art. Streaming services use AI to suggest personalized content, keeping users engaged.

Future Potential and Ethical Considerations

AI's future holds immense potential, with advancements expected in areas like general AI and quantum computing, which could exponentially increase computational power. However, rapid AI development raises ethical and societal concerns, such as data privacy, algorithmic bias, and job displacement. Ensuring AI systems are transparent, fair, and aligned with human values is crucial.

The concept of artificial general intelligence (AGI), where machines surpass human intelligence, poses existential questions about humanity's future. Developing AGI requires careful consideration of safety measures and ethical guidelines to prevent unintended consequences.

Conclusion

The development of artificial intelligence is one of the most significant technological advancements in human history. From its early theoretical foundations to its current applications in everyday life, AI has transformed how we live, work, and interact with the world. As we look to the future, it is essential to navigate the ethical and societal challenges accompanying AI's development, ensuring this powerful technology serves the greater good of humanity."""

    # Replicate into a large document (~5000 words)
    var doc = String("")
    for _ in range(100):
        doc += paragraph

    var t0 = perf_counter_ns()
    var tokens = tokenize(doc)
    var t1 = perf_counter_ns()

    var elapsed_ms = Float64(t1 - t0) / 1_000_000.0
    var tokens_per_sec = (Float64(len(tokens)) / (elapsed_ms / 1000.0))

    print("Tokens extracted:", len(tokens))
    print("Elapsed time:   ", elapsed_ms, "ms")
    print("Throughput:     ", Int(tokens_per_sec), "tokens/sec")

def benchmark_spatial_index() raises:
    print("\n--- 2. Spatial Grid Collision Benchmark ---")
    var index = SpatialGridIndex(1000.0, 1000.0, cell_size=32.0)

    # Insert 100 non-overlapping rects
    var t0 = perf_counter_ns()
    for i in range(10):
        for j in range(10):
            var r = Rect(Float64(i * 90 + 10), Float64(j * 90 + 10), 70.0, 70.0)
            index.insert(r)
    var t1 = perf_counter_ns()

    # Query 1000 random candidate positions
    var coll_count = 0
    var t2 = perf_counter_ns()
    for k in range(1000):
        var q = Rect(Float64((k * 37) % 950), Float64((k * 73) % 950), 60.0, 40.0)
        if index.collides(q, padding=2.0):
            coll_count += 1
    var t3 = perf_counter_ns()

    var insert_ms = Float64(t1 - t0) / 1_000_000.0
    var query_ms = Float64(t3 - t2) / 1_000_000.0

    print("100 Rects Insertion:  ", insert_ms, "ms")
    print("1,000 Collision Queries:", query_ms, "ms (", Int(1000.0 / (query_ms / 1000.0)), "queries/sec)")
    print("Collisions detected:   ", coll_count)

def benchmark_end_to_end() raises:
    print("\n--- 3. End-to-End Generation Benchmark ---")
    var raw = (
        "performance compiler acceleration vectorization optimization "
        "concurrency distributed tensor hardware efficiency "
        "modularity architecture scalability robustness throughput "
        "parallelism instruction pipeline execution algorithm"
    )
    var word_parts = raw.split(" ")
    var words = List[String]()
    for i in range(len(word_parts)):
        words.append(String(word_parts[i]))

    var freqs = Dict[String, Int]()
    for i in range(len(words)):
        freqs[words[i]] = (len(words) - i) * 10

    var cloud = WordCloud(
        width=1200,
        height=800,
        min_font_size=12.0,
        max_font_size=90.0,
        padding=3.0,
        random_seed=42,
    )

    var t0 = perf_counter_ns()
    var result = cloud.generate_from_frequencies(freqs)
    var t1 = perf_counter_ns()

    var elapsed_ms = Float64(t1 - t0) / 1_000_000.0
    print("Words placed: ", result.word_count())
    print("Layout time:  ", elapsed_ms, "ms")

    var t2 = perf_counter_ns()
    var svg = result.to_svg()
    var t3 = perf_counter_ns()
    var svg_ms = Float64(t3 - t2) / 1_000_000.0
    print("SVG render:   ", svg_ms, "ms (SVG byte length:", svg.byte_length(), ")")

def main() raises:
    print("========================================")
    print("Performance")
    print("========================================")
    benchmark_tokenization()
    benchmark_spatial_index()
    benchmark_end_to_end()
    print("\n========================================")
    print("Benchmarks completed successfully.")
    print("========================================")
