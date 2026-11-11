struct WordCloudConfig(Copyable, Movable):
    """Configuration settings for word cloud generation."""
    var width: Int
    var height: Int
    var min_font_size: Float64
    var max_font_size: Float64
    var font_family: String
    var background_color: String
    var max_words: Int
    var min_frequency: Int
    var min_word_length: Int
    var max_word_length: Int
    var padding: Float64
    var prefer_horizontal: Float64
    var allow_rotation: Bool
    var max_placement_attempts: Int
    var random_seed: Int
    var case_sensitive: Bool

    def __init__(
        out self,
        width: Int = 800,
        height: Int = 600,
        min_font_size: Float64 = 10.0,
        max_font_size: Float64 = 80.0,
        font_family: String = "sans-serif",
        background_color: String = "#ffffff",
        max_words: Int = 200,
        min_frequency: Int = 1,
        min_word_length: Int = 2,
        max_word_length: Int = 30,
        padding: Float64 = 3.0,
        prefer_horizontal: Float64 = 0.9,
        allow_rotation: Bool = True,
        max_placement_attempts: Int = 500,
        random_seed: Int = 42,
        case_sensitive: Bool = False,
    ):
        """Constructs a WordCloudConfig with default values."""
        self.width = width
        self.height = height
        self.min_font_size = min_font_size
        self.max_font_size = max_font_size
        self.font_family = font_family
        self.background_color = background_color
        self.max_words = max_words
        self.min_frequency = min_frequency
        self.min_word_length = min_word_length
        self.max_word_length = max_word_length
        self.padding = padding
        self.prefer_horizontal = prefer_horizontal
        self.allow_rotation = allow_rotation
        self.max_placement_attempts = max_placement_attempts
        self.random_seed = random_seed
        self.case_sensitive = case_sensitive

    def validate(self) raises:
        """Validates configuration parameters and raises an Error on invalid values."""
        if self.width <= 0:
            raise Error("Canvas width must be greater than 0")
        if self.height <= 0:
            raise Error("Canvas height must be greater than 0")
        if self.min_font_size <= 0.0:
            raise Error("min_font_size must be greater than 0")
        if self.max_font_size < self.min_font_size:
            raise Error("max_font_size must be greater than or equal to min_font_size")
        if self.max_words <= 0:
            raise Error("max_words must be greater than 0")
        if self.min_frequency <= 0:
            raise Error("min_frequency must be greater than 0")
        if self.min_word_length <= 0:
            raise Error("min_word_length must be greater than 0")
        if self.max_word_length < self.min_word_length:
            raise Error("max_word_length must be greater than or equal to min_word_length")
        if self.padding < 0.0:
            raise Error("padding cannot be negative")
        if self.prefer_horizontal < 0.0 or self.prefer_horizontal > 1.0:
            raise Error("prefer_horizontal must be between 0.0 and 1.0")
        if self.max_placement_attempts <= 0:
            raise Error("max_placement_attempts must be greater than 0")
