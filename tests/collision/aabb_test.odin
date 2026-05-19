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
	testing.expect(t, width == 0, "It should be zero")
}
