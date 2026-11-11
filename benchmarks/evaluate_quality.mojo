from std.collections import List, Dict, Set
from wordcloud import (
    WordCloud,
    WordCloudConfig,
    WordCloudResult,
    WordCloudLayout,
    Rect,
    Palette,
    tokenize,
    compute_frequencies,
    get_default_stopwords,
)
from std.time import perf_counter_ns

def create_sample_frequencies(count: Int) -> Dict[String, Int]:
    var words = (
        "mojo performance compiler acceleration vectorization optimization "
        "concurrency distributed tensor hardware efficiency modularity "
        "architecture scalability robustness throughput parallelism "
        "instruction pipeline execution algorithm memory safety typing "
        "kernel fusion cache latency bandwidth register simd automated "
        "testing benchmarking profiling telemetry asynchronous graphics "
        "rendering vision language robotics networks framework library "
        "developer usability syntax flexibility native python rust zero "
        "abstraction generic trait value copy move heap stack uniform "
        "partitioning spatial grid index collision bounding box spiral "
        "archimedean orientation typography glyph dimensions scalable "
        "viewbox canvas background palette monochrome pastel viridis "
        "contrast gradient interpolation serialize export browser parser"
    )
    var parts = words.split(" ")
    var freqs = Dict[String, Int]()
    var n = min(count, len(parts))
    for i in range(n):
        var w = String(parts[i])
        freqs[w] = (n - i) * 5 + 10
    return freqs^

def evaluate_scenario(
    canvas_w: Int,
    canvas_h: Int,
    min_font: Float64,
    max_font: Float64,
    padding: Float64,
    word_count: Int,
    max_attempts: Int,
    scenario_name: String,
) raises:
    var freqs = create_sample_frequencies(word_count)
    var num_input = len(freqs)

    var cloud = WordCloud(
        width=canvas_w,
        height=canvas_h,
        min_font_size=min_font,
        max_font_size=max_font,
        padding=padding,
        max_placement_attempts=max_attempts,
        random_seed=42,
    )

    var t0 = perf_counter_ns()
    var result = cloud.generate_from_frequencies(freqs)
    var t1 = perf_counter_ns()
    var layout_ms = Float64(t1 - t0) / 1_000_000.0

    var placed_words = result.words()
    var placed_count = len(placed_words)
    var placement_pct = (Float64(placed_count) / Float64(num_input)) * 100.0

    # Calculate actual overlaps
    var overlap_count = 0
    var total_placed_area: Float64 = 0.0
    var canvas_rect = Rect(0.0, 0.0, Float64(canvas_w), Float64(canvas_h))
    var out_of_bounds_count = 0

    for i in range(placed_count):
        var b_i = placed_words[i].bounds()
        total_placed_area += (b_i.width * b_i.height)
        if not canvas_rect.contains(b_i):
            out_of_bounds_count += 1
        for j in range(i + 1, placed_count):
            var b_j = placed_words[j].bounds()
            if b_i.intersects(b_j, padding=padding - 0.01):
                overlap_count += 1

    var canvas_area = Float64(canvas_w * canvas_h)
    var utilization = (total_placed_area / canvas_area) * 100.0

    print("--------------------------------------------------------------------------------")
    print(scenario_name)
    print("Canvas:", canvas_w, "x", canvas_h, "| Font:", min_font, "-", max_font, "| Padding:", padding)
    print("Input words:            ", num_input)
    print("Successfully placed:    ", placed_count)
    print("Placement success rate: ", placement_pct, "%")
    print("Layout time:            ", layout_ms, "ms")
    print("Pairwise overlaps:      ", overlap_count)
    print("Out-of-bounds words:    ", out_of_bounds_count)
    print("Canvas area utilization:", utilization, "%")

def main() raises:
    print("================================================================================")
    print("EVALUATING CURRENT BASELINE LAYOUT QUALITY ACROSS MULTIPLE CONFIGURATIONS")
    print("================================================================================")
    evaluate_scenario(400, 300, 8.0, 40.0, 2.0, 50, 1500, "Scenario 1: Small Canvas (400x300, 50 words)")
    evaluate_scenario(800, 600, 10.0, 70.0, 3.0, 75, 1500, "Scenario 2: Medium Canvas (800x600, 75 words)")
    evaluate_scenario(1200, 800, 12.0, 90.0, 3.0, 75, 1500, "Scenario 3: Large Canvas (1200x800, 75 words)")
    evaluate_scenario(1920, 1080, 14.0, 120.0, 4.0, 75, 1500, "Scenario 4: Full HD Canvas (1920x1080, 75 words)")
