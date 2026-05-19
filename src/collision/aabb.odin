package collision

import "core:fmt"
import rl "vendor:raylib"

AABB :: struct {
	left: i32,
	right: i32,
	bottom: i32,
	top: i32,
}

draw_aabb :: proc(aabb: AABB, color: rl.Color) {
	width := aabb_width(aabb)
	height := aabb_height(aabb)

	assert(width > 0)
	assert(height > 0)

	rl.DrawRectangle(
		aabb.left,
		aabb.top,
		width,
		height,
		color
	)
}

aabb_width :: proc(aabb: AABB) -> i32 {
	return aabb.right - aabb.left
}

aabb_height :: proc(aabb: AABB) -> i32 {
	return aabb.bottom - aabb.top
}

aabb_update_position :: proc(aabb: ^AABB, point: Point) {
	width := aabb_width(aabb^)
	height := aabb_height(aabb^)

	aabb.left = point.x - width / 2
	aabb.top = point.y - height / 2
	aabb.right = aabb.left + width
	aabb.bottom = aabb.top + height
}

aabb_check_point :: proc(aabb: AABB, point: Point) -> bool {
	x_check := aabb.left <= point.x && aabb.right >= point.x
	y_check := aabb.top <= point.y && aabb.bottom >= point.y
	return x_check && y_check
}

aabb_check :: proc(aabb1: AABB, aabb2: AABB) -> bool {
	x_collision := (aabb2.left < aabb1.left && aabb1.left < aabb2.right) ||
		(aabb1.left < aabb2.left && aabb2.left < aabb1.right)

	y_collision := (aabb2.top < aabb1.top && aabb1.top < aabb2.bottom) ||
		(aabb1.top < aabb2.top && aabb2.top < aabb1.bottom)

	return x_collision && y_collision
}

aabb_update_position_with_collision :: proc(aabb: ^AABB, point: Point, aabbs: []AABB) {
	new_aabb := aabb^
	aabb_update_position(&new_aabb, point)

	collide_with: ^AABB = nil
	for &aabb2 in aabbs {
		if aabb == &aabb2 {
			continue
		}
		if aabb_check(new_aabb, aabb2) {
			collide_with = &aabb2
			break
		}
	}

	result_aabb := new_aabb
	if collide_with != nil {
		x_diff := new_aabb.left - aabb.left
		y_diff := new_aabb.top - aabb.top
		if x_diff != 0 && abs(x_diff) >= abs(y_diff) {
			fixed_aabb := aabb_handle_x_axis_collision(result_aabb, collide_with^, x_diff)
			if !aabb_check(fixed_aabb, collide_with^) {
				result_aabb = fixed_aabb
			}
		} else if y_diff != 0 && abs(y_diff) > abs(x_diff) {
			fixed_aabb := aabb_handle_y_axis_collision(result_aabb, collide_with^, y_diff)
			if !aabb_check(fixed_aabb, collide_with^) {
				result_aabb = fixed_aabb
			}
		}
	}

	aabb^ = result_aabb
}

aabb_handle_x_axis_collision :: proc(aabb1: AABB, aabb2: AABB, diff: i32) -> AABB {
	assert(diff != 0, "The diff argument should be != 0")
	result := aabb1
	width1 := aabb_width(aabb1)
	if diff > 0 {
		result.right = aabb2.left
		result.left = result.right - width1
	} else {
		result.left = aabb2.right
		result.right = result.left + width1
	}

	return result
}

aabb_handle_y_axis_collision :: proc(aabb1: AABB, aabb2: AABB, diff: i32) -> AABB {
	assert(diff != 0, "The diff argument should be != 0")
	result := aabb1
	height1 := aabb_height(aabb1)
	if diff > 0 {
		result.bottom = aabb2.top
		result.top = result.bottom - height1
	} else {
		result.top = aabb2.bottom
		result.bottom = result.top + height1
	}

	return result
}
