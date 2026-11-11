from std.testing import assert_true, assert_equal, TestSuite
from std.collections import List, Dict, Set
from wordcloud.frequency import compute_frequencies, frequencies_from_dict
from wordcloud.types import WordFrequency

def test_compute_frequencies_basic() raises:
    var tokens = List[String]()
    tokens.append("mojo")
    tokens.append("is")
    tokens.append("fast")
    tokens.append("mojo")
    tokens.append("is")
    tokens.append("cool")
    tokens.append("mojo")
    tokens.append("performance")

    var stopwords = Set[String]()
    stopwords.add("is")

    var freqs = compute_frequencies(tokens, stopwords)

    # "is" should be omitted as stopword
    # "mojo": 3, "cool": 1, "fast": 1, "performance": 1
    assert_equal(len(freqs), 4)
    assert_equal(freqs[0].word, "mojo")
    assert_equal(freqs[0].frequency, 3)

def test_min_frequency_filter() raises:
    var tokens = List[String]()
    tokens.append("a")
    tokens.append("b")
    tokens.append("c")
    tokens.append("a")
    tokens.append("b")
    tokens.append("a")

    var stopwords = Set[String]()
    # min_frequency=2
    var freqs = compute_frequencies(tokens, stopwords, min_frequency=2)
    assert_equal(len(freqs), 2)
    assert_equal(freqs[0].word, "a")
    assert_equal(freqs[0].frequency, 3)
    assert_equal(freqs[1].word, "b")
    assert_equal(freqs[1].frequency, 2)

def test_max_words_limit() raises:
    var tokens = List[String]()
    tokens.append("w1")
    tokens.append("w2")
    tokens.append("w3")
    tokens.append("w4")
    tokens.append("w5")

    var stopwords = Set[String]()
    # max_words = 3
    var freqs = compute_frequencies(tokens, stopwords, max_words=3)
    assert_equal(len(freqs), 3)

def test_frequencies_from_dict() raises:
    var user_freqs = Dict[String, Int]()
    user_freqs["Mojo"] = 100
    user_freqs["mojo"] = 50
    user_freqs["Python"] = 70
    user_freqs["C++"] = 30

    var stopwords = Set[String]()
    stopwords.add("python")

    # Case-insensitive merge: "Mojo" and "mojo" merge to 150
    var freqs = frequencies_from_dict(user_freqs, stopwords, case_sensitive=False)

    assert_equal(len(freqs), 2)
    assert_equal(freqs[0].word, "mojo")
    assert_equal(freqs[0].frequency, 150)
    assert_equal(freqs[1].word, "c++")
    assert_equal(freqs[1].frequency, 30)

def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
