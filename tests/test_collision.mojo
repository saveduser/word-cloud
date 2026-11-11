from std.testing import assert_true, assert_false, assert_equal, TestSuite
from wordcloud.types import Rect
from wordcloud.collision import check_collision_aabb, is_within_bounds, SpatialGridIndex

def test_aabb_collision() raises:
    var r1 = Rect(100.0, 100.0, 50.0, 30.0)
    var r2 = Rect(130.0, 110.0, 50.0, 30.0) # overlaps r1
    var r3 = Rect(200.0, 200.0, 50.0, 30.0) # clear

    assert_true(check_collision_aabb(r1, r2))
    assert_false(check_collision_aabb(r1, r3))

def test_boundary_containment() raises:
    var container = Rect(0.0, 0.0, 800.0, 600.0)
    var inside = Rect(10.0, 10.0, 100.0, 50.0)
    var exceeds_right = Rect(750.0, 10.0, 100.0, 50.0)
    var exceeds_bottom = Rect(10.0, 580.0, 100.0, 50.0)
    var negative_coord = Rect(-5.0, 10.0, 50.0, 50.0)

    assert_true(is_within_bounds(inside, container))
    assert_false(is_within_bounds(exceeds_right, container))
    assert_false(is_within_bounds(exceeds_bottom, container))
    assert_false(is_within_bounds(negative_coord, container))

def test_spatial_grid_index() raises:
    var index = SpatialGridIndex(800.0, 600.0, cell_size=50.0)
    assert_equal(index.rect_count(), 0)

    var r1 = Rect(100.0, 100.0, 60.0, 30.0)
    index.insert(r1)
    assert_equal(index.rect_count(), 1)

    # Candidate colliding with r1
    var c1 = Rect(140.0, 110.0, 50.0, 30.0)
    assert_true(index.collides(c1))

    # Candidate outside bounds
    var c_oob = Rect(780.0, 100.0, 50.0, 30.0)
    assert_true(index.collides(c_oob))

    # Candidate in free area
    var c_free = Rect(300.0, 300.0, 40.0, 20.0)
    assert_false(index.collides(c_free))

    # Insert second rect
    index.insert(c_free)
    assert_equal(index.rect_count(), 2)

    # Now c_free area collides
    assert_true(index.collides(c_free))

def test_spatial_grid_padding() raises:
    var index = SpatialGridIndex(800.0, 600.0, cell_size=40.0)
    var r1 = Rect(100.0, 100.0, 50.0, 50.0) # [100, 150]
    index.insert(r1)

    var candidate = Rect(155.0, 100.0, 50.0, 50.0) # gap of 5.0
    # Without padding, no collision
    assert_false(index.collides(candidate, padding=0.0))
    # With padding of 6.0, collision
    assert_true(index.collides(candidate, padding=6.0))

def test_spatial_grid_clear() raises:
    var index = SpatialGridIndex(800.0, 600.0)
    index.insert(Rect(50.0, 50.0, 100.0, 50.0))
    assert_equal(index.rect_count(), 1)
    index.clear()
    assert_equal(index.rect_count(), 0)
    # Area should now be free
    assert_false(index.collides(Rect(50.0, 50.0, 100.0, 50.0)))

def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
