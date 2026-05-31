package collision

AABB :: struct {
	left: f32,
	right: f32,
	top: f32,
	bottom: f32,
}

aabb_width :: proc(aabb: AABB) -> f32 {
	return aabb.right - aabb.left
}

aabb_height :: proc(aabb: AABB) -> f32 {
	return aabb.bottom - aabb.top
}

aabb_center :: proc(aabb: AABB) -> Point {
	w := aabb_width(aabb)
	h := aabb_height(aabb)
	return Point{
		x = aabb.left + w / 2,
		y = aabb.top + h / 2,
	}
}

aabb_update_position :: proc(aabb: ^AABB, point: Point) {
	width := aabb_width(aabb^)
	height := aabb_height(aabb^)

	aabb.left = point.x
	aabb.top = point.y
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

	result := new_aabb
	if collide_with != nil {
		result = aabb_collide_update(aabb^, new_aabb, collide_with^)
	}
	aabb^ = result
}

aabb_collide_update :: proc(aabb: AABB, new_aabb: AABB, collided: AABB) -> AABB {
	result_aabb := new_aabb

	x_diff: f32 = -new_aabb.left + aabb.left
	y_diff: f32 = -new_aabb.top + aabb.top

	if abs(x_diff) > abs(y_diff) {
		fixed_aabb := aabb_handle_x_axis_collision(result_aabb, collided, x_diff)
		if !aabb_check(fixed_aabb, collided) {
			result_aabb = fixed_aabb
		}
	} else {
		fixed_aabb := aabb_handle_y_axis_collision(result_aabb, collided, y_diff)
		if !aabb_check(fixed_aabb, collided) {
			result_aabb = fixed_aabb
		}
	}

	return result_aabb
}

aabb_handle_x_axis_collision :: proc(aabb1: AABB, aabb2: AABB, diff: f32) -> AABB {
	if diff == 0 {
		return aabb1
	}
	result := aabb1
	width1 := aabb_width(aabb1)
	if diff > 0 {
		result.left = aabb2.right
		result.right = result.left + width1
	} else {
		result.right = aabb2.left
		result.left = result.right - width1
	}

	return result
}

aabb_handle_y_axis_collision :: proc(aabb1: AABB, aabb2: AABB, diff: f32) -> AABB {
	if diff == 0 {
		return aabb1
	}
	result := aabb1
	height1 := aabb_height(aabb1)
	if diff > 0 {
		result.top = aabb2.bottom
		result.bottom = result.top + height1
	} else {
		result.bottom = aabb2.top
		result.top = result.bottom - height1
	}

	return result
}
