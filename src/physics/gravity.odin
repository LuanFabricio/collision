package physics

import "../collision"

GRAVITY_FORCE :: 100.0

MAX_Y :: 480

apply_gravity_aabb :: proc(aabb: ^collision.AABB, frame_time: f32, aabb_arr: []collision.AABB) {
	center := collision.aabb_center(aabb^)

	center.y += GRAVITY_FORCE * frame_time

	height := collision.aabb_height(aabb^)
	collision.aabb_update_position_with_collision(aabb, center, aabb_arr)

	aabb.bottom = min(MAX_Y, aabb.bottom)
	aabb.top = aabb.bottom - height
}
