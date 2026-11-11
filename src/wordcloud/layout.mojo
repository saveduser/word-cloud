from std.collections import List
from std.math import cos, sin, sqrt, min, max
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
    """Placement engine for positioning words on the canvas using elliptical Archimedean spirals."""
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
        var max_radius = sqrt(center_x * center_x + center_y * center_y) + 30.0

        var num_colors = len(colors)

        # Radial step scaled to canvas diagonal
        var r_step = max(0.40, min(0.85, max_radius / 1200.0))

        # Progressive font scaling passes
        var scale_factors = List[Float64]()
        scale_factors.append(1.0)
        scale_factors.append(0.82)
        scale_factors.append(0.67)
        scale_factors.append(0.52)

        for i in range(n_words):
            var wf = frequencies[i].copy()
            var font_size = font_sizes[i]

            # Primary orientation decision
            var primary_is_vertical = False
            if self.config.allow_rotation:
                primary_is_vertical = not prng.next_bool(self.config.prefer_horizontal)

            # Pick color from palette
            var color = String("#333333")
            if num_colors > 0:
                var color_idx = Int(prng.next_float() * Float64(num_colors))
                if color_idx >= num_colors:
                    color_idx = num_colors - 1
                color = colors[color_idx]

            var placed_successfully = False

            for pass_idx in range(len(scale_factors)):
                var current_size = font_size * scale_factors[pass_idx]
                if current_size < self.config.min_font_size:
                    current_size = self.config.min_font_size

                # Try primary orientation first, then secondary if it didn't fit
                for orient_idx in range(2):
                    var is_vertical = primary_is_vertical
                    if orient_idx == 1:
                        if not self.config.allow_rotation:
                            break
                        is_vertical = not primary_is_vertical

                    var dims = estimate_word_dimensions(
                        wf.word, current_size, self.config.font_family
                    )

                    var bbox_w = dims.width
                    var bbox_h = dims.height
                    if is_vertical:
                        bbox_w = dims.height
                        bbox_h = dims.width

                    # Reject immediately if word dimensions exceed canvas
                    if bbox_w >= Float64(self.config.width) or bbox_h >= Float64(self.config.height):
                        continue

                    # Uniform arc-length stepping
                    var theta_offset = prng.next_float() * 6.283185307179586
                    var r: Float64 = 0.0
                    var theta: Float64 = theta_offset

                    var cx = center_x
                    var cy = center_y
                    if pass_idx > 0:
                        cx += (prng.next_float() - 0.5) * 30.0
                        cy += (prng.next_float() - 0.5) * 30.0

                    var step = 0
                    while step < self.config.max_placement_attempts and r < max_radius:
                        step += 1
                        r += r_step

                        # Adaptive theta step: keeps tangential candidate spacing uniform
                        var d_theta = max(0.04, min(0.12, 6.0 / max(r, 12.0)))
                        theta += d_theta

                        var x = cx + r * cos(theta) * aspect
                        var y = cy + r * sin(theta)

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

                if placed_successfully:
                    break

        return placed^
