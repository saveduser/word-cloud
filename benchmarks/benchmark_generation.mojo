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
    var paragraph = (
        "Mojo is a modern systems programming language that synthesizes the developer friendliness "
        "of Python with the raw execution speed and memory control of C, C++, and Rust. "
        "Designed for AI hardware acceleration, machine learning compilers, and high-performance "
        "heterogeneous computing, Mojo delivers strong static typing, compile-time metaprogramming, "
        "zero-cost abstractions, full ownership semantics, and automatic vectorization with SIMD. "
    )

    # Replicate into a large document (~5600 words)
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

    # Query 1000 candidate positions
    var coll_count = 0
    var t2 = perf_counter_ns()
    for k in range(1000):
        var q = Rect(Float64((k * 37) % 950), Float64((k * 73) % 950), 60.0, 40.0)
        if index.collides(q, padding=2.0):
            coll_count += 1
    var t3 = perf_counter_ns()

    var insert_ms = Float64(t1 - t0) / 1_000_000.0
    var query_ms = Float64(t3 - t2) / 1_000_000.0

    print("100 Rects Insertion:    ", insert_ms, "ms")
    print("1,000 Collision Queries:", query_ms, "ms (", Int(1000.0 / (query_ms / 1000.0)), "queries/sec)")
    print("Collisions detected:     ", coll_count)

def benchmark_end_to_end() raises:
    print("\n--- 3. End-to-End Generation Benchmark (Medium & Large) ---")
    var raw = (
        "performance compiler acceleration vectorization optimization "
        "concurrency distributed tensor hardware efficiency "
        "modularity architecture scalability robustness throughput "
        "parallelism instruction pipeline execution algorithm "
        "memory safety typing kernel fusion cache latency "
        "bandwidth register simd automated testing profiling "
        "telemetry asynchronous graphics rendering vision robotics "
        "networks framework developer usability flexibility python "
        "rust zero abstraction generic trait value copy "
        "move heap stack uniform partitioning spatial grid "
        "index collision bounding box spiral archimedean orientation "
        "typography glyph scalable viewbox canvas background palette "
        "monochrome pastel viridis contrast gradient interpolation"
    )
    var word_parts = raw.split(" ")
    var freqs = Dict[String, Int]()
    for i in range(len(word_parts)):
        var w = String(word_parts[i])
        freqs[w] = (len(word_parts) - i) * 3 + 10

    var cloud = WordCloud(
        width=1200,
        height=800,
        min_font_size=12.0,
        max_font_size=85.0,
        padding=3.0,
        random_seed=42,
    )

    var t0 = perf_counter_ns()
    var result = cloud.generate_from_frequencies(freqs)
    var t1 = perf_counter_ns()

    var elapsed_ms = Float64(t1 - t0) / 1_000_000.0
    print("Input unique words:      ", len(freqs))
    print("Successfully placed:     ", result.word_count(), "(", (Float64(result.word_count()) / Float64(len(freqs))) * 100.0, "%)")
    print("Layout time:             ", elapsed_ms, "ms")

    var t2 = perf_counter_ns()
    var svg = result.to_svg()
    var t3 = perf_counter_ns()
    var svg_ms = Float64(t3 - t2) / 1_000_000.0
    print("SVG render time:         ", svg_ms, "ms (SVG size:", svg.byte_length(), "bytes)")

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
