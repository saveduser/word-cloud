from std.collections import List, Dict, Set
from wordcloud.types import Rect, WordFrequency, PlacedWord
from wordcloud.config import WordCloudConfig
from wordcloud.tokenizer import Tokenizer, tokenize
from wordcloud.stopwords import get_default_stopwords
from wordcloud.frequency import compute_frequencies, frequencies_from_dict
from wordcloud.color import Palette
from wordcloud.layout import WordCloudLayout
from wordcloud.exporters.svg import export_svg, save_svg

struct WordCloudResult(Copyable, Movable):
    """Result of word cloud generation, containing positioned words and export capabilities."""
    var placed_words: List[PlacedWord]
    var config: WordCloudConfig

    def __init__(out self, placed_words: List[PlacedWord], config: WordCloudConfig):
        self.placed_words = placed_words.copy()
        self.config = config.copy()

    def words(self) -> List[PlacedWord]:
        """Returns the list of placed words with their coordinates and dimensions."""
        return self.placed_words.copy()

    def word_count(self) -> Int:
        """Returns the number of successfully placed words."""
        return len(self.placed_words)

    def to_svg(self) -> String:
        """Renders the word cloud as an SVG document string."""
        return export_svg(
            self.placed_words,
            self.config.width,
            self.config.height,
            self.config.background_color,
            self.config.font_family,
        )

    def save_svg(self, path: String) raises:
        """Saves the word cloud SVG to a file."""
        save_svg(self.to_svg(), path)

struct WordCloud(Copyable, Movable):
    """Main word cloud generator for pure Mojo applications."""
    var config: WordCloudConfig
    var palette: Palette
    var stopwords: Set[String]

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
        self.config = WordCloudConfig(
            width=width,
            height=height,
            min_font_size=min_font_size,
            max_font_size=max_font_size,
            font_family=font_family,
            background_color=background_color,
            max_words=max_words,
            min_frequency=min_frequency,
            min_word_length=min_word_length,
            max_word_length=max_word_length,
            padding=padding,
            prefer_horizontal=prefer_horizontal,
            allow_rotation=allow_rotation,
            max_placement_attempts=max_placement_attempts,
            random_seed=random_seed,
            case_sensitive=case_sensitive,
        )
        self.palette = Palette.classic()
        self.stopwords = get_default_stopwords()

    def set_palette(mut self, palette: Palette):
        """Sets the color palette used for word rendering."""
        self.palette = Palette(palette.get_colors())

    def set_stopwords(mut self, stopwords: Set[String]):
        """Sets custom stopwords."""
        self.stopwords = stopwords.copy()

    def generate(self, text: String) raises -> WordCloudResult:
        """Generates a word cloud from raw text input."""
        self.config.validate()

        var tokens = tokenize(
            text,
            min_length=self.config.min_word_length,
            max_length=self.config.max_word_length,
            case_sensitive=self.config.case_sensitive,
        )

        var freqs = compute_frequencies(
            tokens,
            self.stopwords,
            min_frequency=self.config.min_frequency,
            max_words=self.config.max_words,
        )

        var layout = WordCloudLayout(self.config)
        var placed = layout.place(freqs, self.palette.get_colors())
        return WordCloudResult(placed, self.config)

    def generate_from_frequencies(
        self,
        frequencies: Dict[String, Int],
    ) raises -> WordCloudResult:
        """Generates a word cloud from precomputed word frequency dictionary."""
        self.config.validate()

        var freqs = frequencies_from_dict(
            frequencies,
            self.stopwords,
            min_frequency=self.config.min_frequency,
            max_words=self.config.max_words,
            case_sensitive=self.config.case_sensitive,
        )

        var layout = WordCloudLayout(self.config)
        var placed = layout.place(freqs, self.palette.get_colors())
        return WordCloudResult(placed, self.config)
