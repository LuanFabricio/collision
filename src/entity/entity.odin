package entity

import "core:slice"

import "../collision"
import "../input"

Entity :: struct {
	aabb: collision.AABB,
	velocity: [2]f32,
	speed: f32
}

entity_move :: proc(entity: ^Entity, entities: []Entity, frame_time: f32) {
	new_pos := collision.point_to_vector2(collision.aabb_center(entity.aabb))
	new_pos += entity.velocity * entity.speed * frame_time

	aabbs := slice.mapper(
		entities,
		proc(x: Entity) -> collision.AABB { return x.aabb },
	)
	collision.aabb_update_position_with_collision(
		&entity.aabb,
		collision.vector2_to_point(new_pos),
		aabbs
	)
}
