from std.testing import assert_true, assert_false, assert_equal, TestSuite
from std.collections import List, Set
from wordcloud.stopwords import (
    get_default_stopwords,
    create_stopwords,
    add_stopwords,
    remove_stopwords,
)

def test_default_stopwords() raises:
    var sw = get_default_stopwords()
    assert_true("the" in sw)
    assert_true("and" in sw)
    assert_true("is" in sw)
    assert_true("in" in sw)
    assert_false("mojo" in sw)
    assert_false("computer" in sw)

def test_create_stopwords_without_default() raises:
    var custom = List[String]()
    custom.append("mojo")
    custom.append("python")
    custom.append("rust")
    var sw = create_stopwords(custom, include_default=False)
    assert_true("mojo" in sw)
    assert_true("python" in sw)
    assert_true("rust" in sw)
    assert_false("the" in sw)

def test_create_stopwords_with_default() raises:
    var custom = List[String]()
    custom.append("mojo")
    custom.append("programming")
    var sw = create_stopwords(custom, include_default=True)
    assert_true("the" in sw)
    assert_true("mojo" in sw)
    assert_true("programming" in sw)

def test_add_remove_stopwords() raises:
    var sw = Set[String]()
    var add_list = List[String]()
    add_list.append("apple")
    add_list.append("banana")
    add_stopwords(sw, add_list)
    assert_true("apple" in sw)
    assert_true("banana" in sw)

    var remove_list = List[String]()
    remove_list.append("apple")
    remove_stopwords(sw, remove_list)
    assert_false("apple" in sw)
    assert_true("banana" in sw)

def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
