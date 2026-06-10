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

Axis :: enum { None, X, Y }

entity_move :: proc(entity: ^Entity, world: World, frame_time: f32) {
	new_pos := rl.Vector2{entity.aabb.left, entity.aabb.top}

	// new_pos += entity.velocity * frame_time

	new_pos.x += entity.velocity.x * frame_time;
	handle_collision(entity, new_pos, world, Axis.X)

	new_pos = rl.Vector2{entity.aabb.left, entity.aabb.top}
	new_pos.y += entity.velocity.y * frame_time;
	handle_collision(entity, new_pos, world, Axis.Y)
}

@(private="file")
handle_collision :: proc(entity: ^Entity, new_pos: rl.Vector2, world: World, axis: Axis = Axis.None) {
	new_aabb := entity.aabb
	entities_aabbs: [dynamic]collision.AABB
	// slice.mapper(
	// 	world.entities[:],
 	// 	proc(x: Entity) -> collision.AABB { return x.aabb },
 	// )
	for &map_entity in world.entities {
		if &map_entity == entity {
			continue
		}
		append(&entities_aabbs, map_entity.aabb)
	}

	aabbs := slice.concatenate([][]collision.AABB{entities_aabbs[:], world.aabbs[:]})

	#partial switch axis {
		case Axis.X:
			collision.aabb_update_x_with_collision(&new_aabb, new_pos.x, aabbs[:])
		case Axis.Y:
			collision.aabb_update_y_with_collision(&new_aabb, new_pos.y, aabbs[:])
		case:
			collision.aabb_update_position_with_collision(
				&new_aabb,
				collision.vector2_to_point(new_pos),
				aabbs[:]
			)
	}

	height := collision.aabb_height(new_aabb)
	new_aabb.bottom = min(world.floor.top, new_aabb.bottom)
	new_aabb.top = new_aabb.bottom - height

	entity.aabb = new_aabb
}
