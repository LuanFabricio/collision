package test_collision

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

// TODO: write a test for aabb_update_position_with_collision
@(test)
aabb_update_position_with_collision :: proc(t: ^testing.T) {
	items := []collision.AABB{
		{
			left = 0, right = 42,
			top = 0, bottom = 42,
		},
		{
			left = 21, right = 63,
			top = 21, bottom = 63,
		}
	}

	aabb := &items[0]
	target := collision.Point{items[1].left, items[1].top}
	collision.aabb_update_position_with_collision(aabb, target, items)

	width := collision.aabb_width(aabb^)
	height := collision.aabb_height(aabb^)

	aabb2 := items[1]
	testing.expect_value(t, aabb.top, aabb2.top - height)
	testing.expect_value(t, aabb.bottom, aabb2.top)
	testing.expect_value(t, aabb.left, aabb2.left - width)
	testing.expect_value(t, aabb.right, aabb2.left)
}
