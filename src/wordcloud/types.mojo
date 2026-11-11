from std.math import max, min

@fieldwise_init
struct Rect(Copyable, Movable):
    """Represents a 2D axis-aligned bounding box."""
    var x: Float64
    var y: Float64
    var width: Float64
    var height: Float64

    def left(self) -> Float64:
        """Returns the left edge x-coordinate."""
        return self.x

    def right(self) -> Float64:
        """Returns the right edge x-coordinate."""
        return self.x + self.width

    def top(self) -> Float64:
        """Returns the top edge y-coordinate."""
        return self.y

    def bottom(self) -> Float64:
        """Returns the bottom edge y-coordinate."""
        return self.y + self.height

    def intersects(self, other: Rect, padding: Float64 = 0.0) -> Bool:
        """Determines if this rectangle intersects another, accounting for padding."""
        if self.right() + padding <= other.left():
            return False
        if self.left() >= other.right() + padding:
            return False
        if self.bottom() + padding <= other.top():
            return False
        if self.top() >= other.bottom() + padding:
            return False
        return True

    def contains(self, inner: Rect) -> Bool:
        """Determines if inner rectangle is completely contained within this rectangle."""
        return (
            inner.left() >= self.left()
            and inner.right() <= self.right()
            and inner.top() >= self.top()
            and inner.bottom() <= self.bottom()
        )


@fieldwise_init
struct WordFrequency(Comparable, Copyable, Movable):
    """Represents a word and its associated frequency count.
    
    Comparable implementation sorts by descending frequency, then alphabetical.
    """
    var word: String
    var frequency: Int

    def __lt__(self, other: WordFrequency) -> Bool:
        if self.frequency != other.frequency:
            return self.frequency > other.frequency
        return self.word < other.word

    def __le__(self, other: WordFrequency) -> Bool:
        if self.frequency != other.frequency:
            return self.frequency > other.frequency
        return self.word <= other.word

    def __gt__(self, other: WordFrequency) -> Bool:
        if self.frequency != other.frequency:
            return self.frequency < other.frequency
        return self.word > other.word

    def __ge__(self, other: WordFrequency) -> Bool:
        if self.frequency != other.frequency:
            return self.frequency < other.frequency
        return self.word >= other.word

    def __eq__(self, other: WordFrequency) -> Bool:
        return self.frequency == other.frequency and self.word == other.word

    def __ne__(self, other: WordFrequency) -> Bool:
        return self.frequency != other.frequency or self.word != other.word


@fieldwise_init
struct PlacedWord(Copyable, Movable):
    """Represents a word successfully positioned on the word cloud canvas."""
    var word: String
    var frequency: Int
    var font_size: Float64
    var x: Float64
    var y: Float64
    var width: Float64
    var height: Float64
    var is_vertical: Bool
    var color: String

    def bounds(self) -> Rect:
        """Returns the bounding rectangle for this placed word."""
        return Rect(self.x, self.y, self.width, self.height)
