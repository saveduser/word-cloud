from std.collections import List, Dict, Set
from wordcloud.types import WordFrequency

def compute_frequencies(
    tokens: List[String],
    stopwords: Set[String],
    min_frequency: Int = 1,
    max_words: Int = 200,
) -> List[WordFrequency]:
    """Computes sorted word frequencies from token list, filtering stopwords and thresholds."""
    var counts = Dict[String, Int]()

    for i in range(len(tokens)):
        var word = tokens[i]
        # Skip if stopword
        if word in stopwords:
            continue
        if word in counts:
            counts[word] = counts[word] + 1
        else:
            counts[word] = 1

    var results = List[WordFrequency]()
    for item in counts.items():
        if item.value >= min_frequency:
            results.append(WordFrequency(item.key, item.value))

    sort(results)

    # Truncate to max_words if necessary
    if len(results) > max_words:
        var truncated = List[WordFrequency]()
        for i in range(max_words):
            truncated.append(results[i])
        return truncated^

    return results^

def frequencies_from_dict(
    frequencies: Dict[String, Int],
    stopwords: Set[String] = Set[String](),
    min_frequency: Int = 1,
    max_words: Int = 200,
    case_sensitive: Bool = False,
) -> List[WordFrequency]:
    """Builds sorted WordFrequency list from user-supplied frequency dictionary."""
    var merged = Dict[String, Int]()

    for item in frequencies.items():
        var w = item.key
        if not case_sensitive:
            w = w.lower()

        if w in stopwords:
            continue

        if w in merged:
            merged[w] = merged[w] + item.value
        else:
            merged[w] = item.value

    var results = List[WordFrequency]()
    for item in merged.items():
        if item.value >= min_frequency:
            results.append(WordFrequency(item.key, item.value))

    sort(results)

    if len(results) > max_words:
        var truncated = List[WordFrequency]()
        for i in range(max_words):
            truncated.append(results[i])
        return truncated^

    return results^
