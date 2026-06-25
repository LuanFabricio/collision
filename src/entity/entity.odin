package entity

import "core:slice"
import "core:fmt"
import "../collision"

Entity :: struct {
	aabb: i32,
	color: i32,
	velocity: [2]f32,
	speed: f32,
}

entity_move :: proc(entity: ^Entity, world: World, frame_time: f32) {
	velocity_frame := entity.velocity * frame_time
	new_aabb := world.aabbs[entity.aabb]
	collided: bool = false

	aabb_width := collision.aabb_width(new_aabb)
	new_aabb.left += velocity_frame.x
	new_aabb.right = new_aabb.left + aabb_width
	new_aabb, collided = handle_collision_x(entity.aabb, new_aabb, world.aabbs[:])

	aabb_height := collision.aabb_height(new_aabb)
	new_aabb.top += velocity_frame.y
	new_aabb.bottom = new_aabb.top + aabb_height
	new_aabb, _ = handle_collision_y(entity.aabb, new_aabb, world.aabbs[:])

	height := collision.aabb_height(new_aabb)
	new_aabb.bottom = min(world.floor.top, new_aabb.bottom)
	new_aabb.top = new_aabb.bottom - height
	world.aabbs[entity.aabb] = new_aabb
}

// TODO: Remove bool return
@(private="file")
handle_collision_x :: proc(entity_aabb: i32, new_aabb: collision.AABB, aabbs: []collision.AABB) -> (collision.AABB, bool) {
	for aabb, i in aabbs {
		if i32(i) == entity_aabb {
			continue
		}
		if collision.aabb_check(aabb, new_aabb) {
			diff := new_aabb.left - aabb.left
			return collision.aabb_handle_x_axis_collision(new_aabb, aabb, diff), true
		}
	}
	return new_aabb, false
}

// TODO: Remove bool return
@(private="file")
handle_collision_y :: proc(entity_aabb: i32, new_aabb: collision.AABB, aabbs: []collision.AABB) -> (collision.AABB, bool) {
	for aabb, i in aabbs {
		if i32(i) == entity_aabb {
			continue
		}
		if collision.aabb_check(aabb, new_aabb) {
			diff := new_aabb.top - aabb.top
			return collision.aabb_handle_y_axis_collision(new_aabb, aabb, diff), true
		}
	}
	return new_aabb, false
}
