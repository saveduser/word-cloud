from std.collections import List
from std.math import cos, sin, min, max
from wordcloud.types import Rect, WordFrequency, PlacedWord
from wordcloud.config import WordCloudConfig
from wordcloud.collision import SpatialGridIndex
from wordcloud.metrics import estimate_word_dimensions, calculate_font_sizes

struct PseudoRandom(Copyable, Movable):
    """Fast, deterministic 64-bit pseudo-random number generator."""
    var state: UInt64

    def __init__(out self, seed: Int):
        var s = UInt64(seed)
        if s == 0:
            s = 123456789
        self.state = s

    def next_u64(mut self) -> UInt64:
        # 64-bit LCG
        self.state = self.state * 6364136223846793005 + 1442695040888963407
        return self.state

    def next_float(mut self) -> Float64:
        """Returns a uniform Float64 in [0.0, 1.0)."""
        var val = self.next_u64() >> 11
        return Float64(val) * (1.0 / 9007199254740992.0)

    def next_bool(mut self, true_probability: Float64 = 0.5) -> Bool:
        return self.next_float() < true_probability

struct WordCloudLayout(Copyable, Movable):
    """Placement engine for positioning words on the canvas using elliptical spirals."""
    var config: WordCloudConfig

    def __init__(out self, config: WordCloudConfig):
        self.config = config.copy()

    def place(
        self,
        frequencies: List[WordFrequency],
        colors: List[String],
    ) -> List[PlacedWord]:
        """Arranges words onto the canvas, returning successfully placed words."""
        var placed = List[PlacedWord]()
        var n_words = len(frequencies)
        if n_words == 0:
            return placed^

        var font_sizes = calculate_font_sizes(
            frequencies,
            self.config.min_font_size,
            self.config.max_font_size,
            scaling="sqrt",
        )

        var spatial_index = SpatialGridIndex(
            Float64(self.config.width),
            Float64(self.config.height),
            cell_size=32.0,
        )

        var prng = PseudoRandom(self.config.random_seed)

        var center_x = Float64(self.config.width) / 2.0
        var center_y = Float64(self.config.height) / 2.0
        var aspect = Float64(self.config.width) / Float64(self.config.height)

        var num_colors = len(colors)

        for i in range(n_words):
            var wf = frequencies[i].copy()
            var font_size = font_sizes[i]

            # Decide orientation
            var is_vertical = False
            if self.config.allow_rotation:
                is_vertical = not prng.next_bool(self.config.prefer_horizontal)

            # Pick color from palette
            var color = String("#333333")
            if num_colors > 0:
                var color_idx = Int(prng.next_float() * Float64(num_colors))
                if color_idx >= num_colors:
                    color_idx = num_colors - 1
                color = colors[color_idx]

            # Try placing at current font size, or reduced size if necessary
            var current_size = font_size
            var placed_successfully = False

            for _ in range(3):
                if current_size < self.config.min_font_size:
                    current_size = self.config.min_font_size

                var dims = estimate_word_dimensions(
                    wf.word, current_size, self.config.font_family
                )

                # Bounding box dimensions depending on orientation
                var bbox_w = dims.width
                var bbox_h = dims.height
                if is_vertical:
                    bbox_w = dims.height
                    bbox_h = dims.width

                # Small initial angular offset based on prng for natural distribution
                var theta_offset = prng.next_float() * 6.283185307179586
                var theta_step: Float64 = 0.10
                var r_step: Float64 = 0.50

                for step in range(self.config.max_placement_attempts):
                    var theta = theta_offset + Float64(step) * theta_step
                    var r = Float64(step) * r_step

                    var x = center_x + r * cos(theta) * aspect
                    var y = center_y + r * sin(theta)

                    var candidate = Rect(
                        x - bbox_w / 2.0,
                        y - bbox_h / 2.0,
                        bbox_w,
                        bbox_h,
                    )

                    if not spatial_index.collides(candidate, self.config.padding):
                        # Spot found!
                        spatial_index.insert(candidate, self.config.padding)
                        var pw = PlacedWord(
                            wf.word,
                            wf.frequency,
                            current_size,
                            candidate.x,
                            candidate.y,
                            bbox_w,
                            bbox_h,
                            is_vertical,
                            color,
                        )
                        placed.append(pw.copy())
                        placed_successfully = True
                        break

                if placed_successfully:
                    break

                # Reduce font size for next pass
                current_size = current_size * 0.75

        return placed^
