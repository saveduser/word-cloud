from std.collections import List
from std.math import min, max
from wordcloud.types import Rect

def check_collision_aabb(a: Rect, b: Rect, padding: Float64 = 0.0) -> Bool:
    """Checks whether two axis-aligned rectangles intersect, accounting for padding."""
    return a.intersects(b, padding)

def is_within_bounds(inner: Rect, container: Rect) -> Bool:
    """Checks whether inner rectangle is completely contained within container rectangle."""
    return container.contains(inner)

struct SpatialGridIndex(Copyable, Movable):
    """Uniform 2D spatial grid index for fast O(1) local collision detection."""
    var canvas_width: Float64
    var canvas_height: Float64
    var cell_size: Float64
    var cols: Int
    var rows: Int
    var rects: List[Rect]
    var grid: List[List[Int]]

    def __init__(
        out self,
        canvas_width: Float64,
        canvas_height: Float64,
        cell_size: Float64 = 32.0,
    ):
        self.canvas_width = canvas_width
        self.canvas_height = canvas_height
        self.cell_size = cell_size
        self.cols = Int(canvas_width / cell_size) + 1
        self.rows = Int(canvas_height / cell_size) + 1
        self.rects = List[Rect]()
        self.grid = List[List[Int]]()

        var total_cells = self.cols * self.rows
        for _ in range(total_cells):
            self.grid.append(List[Int]())

    def bounds(self) -> Rect:
        """Returns the canvas boundary rectangle."""
        return Rect(0.0, 0.0, self.canvas_width, self.canvas_height)

    def insert(mut self, rect: Rect, padding: Float64 = 0.0):
        """Inserts a rectangle into the spatial grid index."""
        var rect_idx = len(self.rects)
        self.rects.append(rect.copy())

        var c_start = max(0, Int((rect.left() - padding) / self.cell_size))
        var c_end = min(self.cols - 1, Int((rect.right() + padding) / self.cell_size))
        var r_start = max(0, Int((rect.top() - padding) / self.cell_size))
        var r_end = min(self.rows - 1, Int((rect.bottom() + padding) / self.cell_size))

        for r in range(r_start, r_end + 1):
            for c in range(c_start, c_end + 1):
                var cell_idx = r * self.cols + c
                self.grid[cell_idx].append(rect_idx)

    def collides(self, candidate: Rect, padding: Float64 = 0.0) -> Bool:
        """Checks if candidate rectangle collides with any placed rectangle or exceeds canvas bounds."""
        # 1. Boundary check
        if not self.bounds().contains(candidate):
            return True

        # 2. Grid cell lookup
        var c_start = max(0, Int((candidate.left() - padding) / self.cell_size))
        var c_end = min(self.cols - 1, Int((candidate.right() + padding) / self.cell_size))
        var r_start = max(0, Int((candidate.top() - padding) / self.cell_size))
        var r_end = min(self.rows - 1, Int((candidate.bottom() + padding) / self.cell_size))

        for r in range(r_start, r_end + 1):
            for c in range(c_start, c_end + 1):
                var cell_idx = r * self.cols + c
                var cell_rects = self.grid[cell_idx].copy()
                for i in range(len(cell_rects)):
                    var idx = cell_rects[i]
                    if candidate.intersects(self.rects[idx], padding):
                        return True

        return False

    def rect_count(self) -> Int:
        """Returns number of placed rectangles."""
        return len(self.rects)

    def clear(mut self):
        """Clears all placed rectangles and resets the spatial grid."""
        self.rects.clear()
        for i in range(len(self.grid)):
            self.grid[i].clear()
