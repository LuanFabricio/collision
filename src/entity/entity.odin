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
	new_aabb, collided = handle_collision_x(world, entity.aabb, new_aabb, world.aabbs[:])

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
handle_collision_x :: proc(world: World, entity_aabb: i32, new_aabb: collision.AABB, aabbs: []collision.AABB, last_collided: i32 = -1) -> (collision.AABB, bool) {
	fmt.printfln("collided: %v", last_collided)
	for &aabb, i in aabbs {
		i := i32(i)
		if i == entity_aabb {
			continue
		}
		if (last_collided != -1) {
			fmt.printfln("aabb: %v vs %v (%v)", new_aabb, aabb, collision.aabb_check(aabb, new_aabb))
		}
		if collision.aabb_check(aabb, new_aabb) {
			assert(last_collided == -1)
			diff := new_aabb.left - aabb.left
			if aabb.mass <= new_aabb.mass {
				// BUG: It pushes the collided AABB but does not apply
				// the push to the following AABBs (if collided with another)
				collided_aabb := collision.aabb_handle_x_axis_collision(aabb, new_aabb, -diff)
				world.aabbs[i], _ = handle_collision_x(world, i, collided_aabb, aabbs, entity_aabb)
				return new_aabb, false
			} else {
				return collision.aabb_handle_x_axis_collision(new_aabb, aabb, diff), true
			}
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
