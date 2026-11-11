from std.testing import assert_equal, TestSuite
from wordcloud import (
    LibraryInfo,
    get_version,
    get_supported_mojo,
)

def test_version_info() raises:
    assert_equal(LibraryInfo.version(), "0.2.0")
    assert_equal(LibraryInfo.supported_mojo(), "1.2.0")
    assert_equal(LibraryInfo.major(), 0)
    assert_equal(LibraryInfo.minor(), 2)
    assert_equal(LibraryInfo.patch(), 0)

def test_version_functions() raises:
    assert_equal(get_version(), "0.2.0")
    assert_equal(get_supported_mojo(), "1.2.0")

def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
