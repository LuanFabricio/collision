package entity

import "core:slice"

import rl "vendor:raylib"

import "../collision"

Entity :: struct {
	aabb: collision.AABB,
	velocity: [2]f32,
	speed: f32
}

World :: struct {
	entities: [dynamic]Entity,
	aabbs: [dynamic]collision.AABB,
	floor: collision.AABB
}

entity_move :: proc(entity: ^Entity, world: World, frame_time: f32) {
	new_pos := collision.point_to_vector2(collision.aabb_center(entity.aabb))
	new_pos += entity.velocity * entity.speed * frame_time

	handle_collision(entity, new_pos, world)
}

@(private="file")
handle_collision :: proc(entity: ^Entity, new_pos: rl.Vector2, world: World) {
	aabbs := slice.mapper(
		world.entities[:],
		proc(x: Entity) -> collision.AABB { return x.aabb },
	)
	collision.aabb_update_position_with_collision(
		&entity.aabb,
		collision.vector2_to_point(new_pos),
		aabbs
	)
}
