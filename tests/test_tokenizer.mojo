from std.testing import assert_true, assert_equal, TestSuite
from wordcloud.tokenizer import Tokenizer, tokenize

def test_empty_input() raises:
    var tokens = tokenize("")
    assert_equal(len(tokens), 0)

    var whitespace_only = tokenize("   \t\n\r  ")
    assert_equal(len(whitespace_only), 0)

def test_basic_tokenization() raises:
    var text = "Mojo is a fast and expressive language!"
    var tokens = tokenize(text)
    # Default is case-insensitive, min_length=2
    # "is", "fast", "and", "expressive", "language" (len=5; "a" is length 1, omitted)
    assert_equal(len(tokens), 6)
    assert_equal(tokens[0], "mojo")
    assert_equal(tokens[1], "is")
    assert_equal(tokens[2], "fast")
    assert_equal(tokens[3], "and")
    assert_equal(tokens[4], "expressive")
    assert_equal(tokens[5], "language")

def test_punctuation_and_whitespace() raises:
    var text = "Hello... World?! (Testing, [brackets] & {braces}: 100%)."
    var tokens = tokenize(text)
    assert_equal(tokens[0], "hello")
    assert_equal(tokens[1], "world")
    assert_equal(tokens[2], "testing")
    assert_equal(tokens[3], "brackets")
    assert_equal(tokens[4], "braces")
    assert_equal(tokens[5], "100")

def test_case_sensitivity() raises:
    var text = "Mojo mojo MOJO"
    var case_insensitive = tokenize(text, case_sensitive=False)
    assert_equal(case_insensitive[0], "mojo")
    assert_equal(case_insensitive[1], "mojo")
    assert_equal(case_insensitive[2], "mojo")

    var case_sensitive = tokenize(text, case_sensitive=True)
    assert_equal(case_sensitive[0], "Mojo")
    assert_equal(case_sensitive[1], "mojo")
    assert_equal(case_sensitive[2], "MOJO")

def test_contractions() raises:
    var text = "It's don't they'll language's"
    var tokens = tokenize(text)
    assert_equal(len(tokens), 4)
    assert_equal(tokens[0], "it's")
    assert_equal(tokens[1], "don't")
    assert_equal(tokens[2], "they'll")
    assert_equal(tokens[3], "language's")

def test_length_filtering() raises:
    var text = "a ab abc abcd abcde"
    # min_length 3, max_length 4
    var tokens = tokenize(text, min_length=3, max_length=4)
    assert_equal(len(tokens), 2)
    assert_equal(tokens[0], "abc")
    assert_equal(tokens[1], "abcd")

def test_unicode_words() raises:
    var text = "Café naïve résumé über"
    var tokens = tokenize(text)
    assert_equal(len(tokens), 4)
    assert_equal(tokens[0], "café")
    assert_equal(tokens[1], "naïve")
    assert_equal(tokens[2], "résumé")
    assert_equal(tokens[3], "über")

def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
