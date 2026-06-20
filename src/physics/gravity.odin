package physics

import "../collision"
import e "../entity"

GRAVITY_FORCE :: 100.0
MAX_VELOCITY :: 250.0

MAX_Y :: 480

apply_gravity_aabb :: proc(aabb: ^collision.AABB, frame_time: f32, aabb_arr: []collision.AABB, max_y: f32 = MAX_Y) {
	center := collision.Point{aabb.left, aabb.top}

	center.y += GRAVITY_FORCE * frame_time

	height := collision.aabb_height(aabb^)
	collision.aabb_update_position_with_collision(aabb, center, aabb_arr)

	aabb.bottom = min(max_y, aabb.bottom)
	aabb.top = aabb.bottom - height
}

apply_gravity_entity :: proc(entity: ^e.Entity, frame_time: f32) {
	entity.velocity.y += 10 * GRAVITY_FORCE * frame_time
	entity.velocity.y = min(MAX_VELOCITY, entity.velocity.y)
}
