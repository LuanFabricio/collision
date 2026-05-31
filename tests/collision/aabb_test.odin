package test_collision

import "core:log"
import "core:testing"
import "../../src/collision"

@(test)
aabb_width_should_diff_between_right_and_left :: proc(t: ^testing.T) {
	aabb := collision.AABB{
		left = 32,
		right = 32
	}

	width := collision.aabb_width(aabb)
	testing.expect_value(t, width, 0)

	aabb = collision.AABB{
		left = 0,
		right = 32
	}
	width = collision.aabb_width(aabb)
	testing.expect_value(t, width, 32)

	aabb = collision.AABB{
		left = 32,
		right = 0,
	}
	width = collision.aabb_width(aabb)
	testing.expect_value(t, width, -32)
}

@(test)
aabb_height_should_diff_between_top_and_bottom :: proc(t: ^testing.T) {
	aabb := collision.AABB{
		top = 32,
		bottom = 32,
	}
	height := collision.aabb_height(aabb)
	testing.expect_value(t, height, 0)

	aabb = collision.AABB{
		top = 0,
		bottom = 32,
	}
	height = collision.aabb_height(aabb)
	testing.expect_value(t, height, 32)

	aabb = collision.AABB{
		top = 32,
		bottom = 0,
	}
	height = collision.aabb_height(aabb)
	testing.expect_value(t, height, -32)
}

@(test)
aabb_update_poistion_should_set_left_top_with_point :: proc(t: ^testing.T) {
	aabb := collision.AABB{
		left = 0,
		top = 0,
		right = 32,
		bottom = 32,
	}

	width := collision.aabb_width(aabb)
	height := collision.aabb_height(aabb)

	POINT :: collision.Point{50, 50}

	collision.aabb_update_position(&aabb, POINT)

	testing.expect_value(t, aabb.left, POINT.x)
	testing.expect_value(t, aabb.right, POINT.x + width)

	testing.expect_value(t, aabb.top, POINT.y)
	testing.expect_value(t, aabb.bottom, POINT.y + height)
}

@(test)
aabb_check_point_should_collide_with_point :: proc(t: ^testing.T) {
	AABB :: collision.AABB{
		left = 0,
		top = 0,
		right = 32,
		bottom = 32,
	}

	POINT :: collision.Point{16, 16}

	testing.expect(t, collision.aabb_check_point(AABB, POINT))
}

@(test)
aabb_check_aabb_should_collide :: proc(t: ^testing.T) {
	aabb1 := collision.AABB{
		left = 0,
		top = 0,
		right = 32,
		bottom = 32,
	}

	aabb2 := collision.AABB{
		left = 16,
		top = 16,
		right = 48,
		bottom = 48,
	}

	testing.expect(t, collision.aabb_check(aabb1, aabb2))

	aabb1.left -= 17
	aabb1.right -= 17
	testing.expect(t, !collision.aabb_check(aabb1, aabb2))
}

@(test)
aabb_update_position_with_collision :: proc(t: ^testing.T) {
	WIDTH :: 42
	HEIGHT :: 42

	items := []collision.AABB{
		{
			left = 0, right = WIDTH,
			top = 50, bottom = 50 + HEIGHT,
		}
	}

	aabb := collision.AABB{
		left = 1, right = 1 + WIDTH,
		top = 0, bottom = HEIGHT,
	}
	target := collision.Point{aabb.left, aabb.top + 16}

	log.infof("aabb before: %v", aabb)
	original_left := aabb.left
	original_right := aabb.right
	collision.aabb_update_position_with_collision(&aabb, target, items)

	aabb2 := items[len(items)-1]
	log.infof("aabb after: %v", aabb)
	log.infof("aabb2: %v", aabb2)

	testing.expect_value(t, aabb.left, original_left)
	testing.expect_value(t, aabb.right, original_right)
	testing.expect_value(t, aabb.top, aabb2.top - HEIGHT)
	testing.expect_value(t, aabb.bottom, aabb2.top)
}

//TODO: Create a test case for aabb_update_position_with_collision
// to test the follwing edgecases:
// - Collisin between 2 AABBs with the same **left** and **right** values
// - Collisin between 2 AABBs with the same **top** and **bottom** values
