package collision

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
	x_collision := (aabb2.left <= aabb1.left && aabb1.left <= aabb2.right) ||
		(aabb1.left <= aabb2.left && aabb2.left <= aabb1.right)

	y_collision := (aabb2.top <= aabb1.top && aabb1.top <= aabb2.bottom) ||
		(aabb1.top <= aabb2.top && aabb2.top <= aabb1.bottom)

	return x_collision && y_collision
}
