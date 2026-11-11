from std.collections import List

def is_word_codepoint(cp: Int) -> Bool:
    """Returns True if the codepoint is an ASCII letter, digit, or Unicode non-ASCII."""
    # ASCII A-Z
    if cp >= 65 and cp <= 90:
        return True
    # ASCII a-z
    if cp >= 97 and cp <= 122:
        return True
    # ASCII 0-9
    if cp >= 48 and cp <= 57:
        return True
    # Unicode non-ASCII (treat all multi-byte UTF-8 codepoints above 127 as word chars)
    if cp > 127:
        return True
    return False

def is_apostrophe(cp: Int) -> Bool:
    """Returns True if the codepoint is a straight or typographic apostrophe."""
    # 39: ', 8217: ’
    return cp == 39 or cp == 8217

struct Tokenizer(Copyable, Movable):
    """Configurable text tokenizer for word cloud extraction."""
    var min_length: Int
    var max_length: Int
    var case_sensitive: Bool

    def __init__(
        out self,
        min_length: Int = 2,
        max_length: Int = 30,
        case_sensitive: Bool = False,
    ):
        self.min_length = min_length
        self.max_length = max_length
        self.case_sensitive = case_sensitive

    def tokenize(self, text: String) -> List[String]:
        """Extracts words from raw text, filtering by length and handling case sensitivity."""
        var tokens = List[String]()
        if text.byte_length() == 0:
            return tokens^

        var cps = List[Int]()
        for cp in text.codepoints():
            cps.append(Int(cp))

        var num_cps = len(cps)
        var current_word = String("")

        for i in range(num_cps):
            var cp = cps[i]

            if is_word_codepoint(cp):
                current_word += chr(cp)
            elif is_apostrophe(cp) and len(current_word.codepoints()) > 0 and (i + 1 < num_cps) and is_word_codepoint(cps[i + 1]):
                # Internal apostrophe (e.g. don't, it's)
                current_word += chr(cp)
            else:
                # Separator encountered (whitespace or punctuation)
                if len(current_word.codepoints()) > 0:
                    var wlen = len(current_word.codepoints())
                    if wlen >= self.min_length and wlen <= self.max_length:
                        if self.case_sensitive:
                            tokens.append(current_word)
                        else:
                            tokens.append(current_word.lower())
                    current_word = String("")

        # Flush any trailing word
        if len(current_word.codepoints()) > 0:
            var wlen = len(current_word.codepoints())
            if wlen >= self.min_length and wlen <= self.max_length:
                if self.case_sensitive:
                    tokens.append(current_word)
                else:
                    tokens.append(current_word.lower())

        return tokens^

def tokenize(
    text: String,
    min_length: Int = 2,
    max_length: Int = 30,
    case_sensitive: Bool = False,
) -> List[String]:
    """Convenience function to tokenize text with given parameters."""
    var tok = Tokenizer(min_length, max_length, case_sensitive)
    return tok.tokenize(text)
