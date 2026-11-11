"""Version and compatibility metadata for the pure Mojo Word Cloud library."""

struct LibraryInfo:
    """Provides semantic versioning and compiler compatibility information."""
    @staticmethod
    def version() -> String:
        """Returns the library semantic version string."""
        return "0.2.0"

    @staticmethod
    def supported_mojo() -> String:
        """Returns the primary supported Mojo compiler version."""
        return "1.2.0"

    @staticmethod
    def major() -> Int:
        return 0

    @staticmethod
    def minor() -> Int:
        return 2

    @staticmethod
    def patch() -> Int:
        return 0

def get_version() -> String:
    """Returns the library semantic version string."""
    return LibraryInfo.version()

def get_supported_mojo() -> String:
    """Returns the primary supported Mojo compiler version."""
    return LibraryInfo.supported_mojo()
