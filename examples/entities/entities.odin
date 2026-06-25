package entities

import "core:slice"
import "core:fmt"
import rl "vendor:raylib"
import c "../../src/collision"
import e "../../src/entity"
import "../../src/input"
import ex ".."
import r "../../src/render"
import "../../src/physics"

world := e.World{}
FLOOR_HEIGHT :: 48

@(private="file")
init :: proc(window: r.Window) {

	e.world_add_entity(
		&world,
		e.Entity{
			aabb = 0,
			velocity = {0, 0},
			speed = 42,
		},
		c.AABB{
			left = 0,
			right = 32,
			top = 0,
			bottom = 32,
		},
		rl.Color{0xff, 0xff, 0xff, 0xff},
	)

	aabb_size := []f32{ 32, 32 }
	for i in 0..<6 {
		width := aabb_size[0] * f32(i)
		height := aabb_size[1] * f32(i)
		append(&world.aabbs, c.AABB{
			left = 50 + width,
			right = 82 + width,
			top = 0,
			bottom = 32 + height,
		})
	}

	world.floor = {
		left = 0,
		right = f32(window.width),
		top = f32(window.height - FLOOR_HEIGHT),
		bottom = f32(window.height),
	}

	append(&world.aabbs, c.AABB{
		left = 50,
		right = 82,
		top = world.floor.top - 32,
		bottom = world.floor.top,
	})

	append(&world.aabbs, c.AABB{
		left = 140,
		right = 172,
		top = world.floor.top - 32,
		bottom = world.floor.top,
	})
}

@(private="file")
deinit :: proc() {
	world.floor = {0, 0, 0, 0}
	delete(world.aabbs)
	delete(world.entities)
}

@(private="file")
render :: proc(window: r.Window) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)

	entities_aabbs := [dynamic]i32{}
	for entity in world.entities {
		r.render_aabb(world.aabbs[entity.aabb], world.colors[entity.color])
		append(&entities_aabbs, entity.aabb)
	}

	for aabb, i in world.aabbs {
		if !slice.contains(entities_aabbs[:], i32(i)) {
			r.render_aabb(aabb, rl.RED)
		}
	}

	r.render_aabb(world.floor, rl.BROWN)

	rl.EndDrawing()
}

@(private="file")
update_loop :: proc(frame_time: f32) {
	if rl.IsWindowResized() {
		 world.floor.right = f32(rl.GetScreenWidth())

		 height := rl.GetScreenHeight()
		 world.floor.top = f32(height - FLOOR_HEIGHT)
		 world.floor.bottom = f32(height)

	}

	move := input.input_get_move_vector2()
	world.entities[0].velocity.x = move.x * world.entities[0].speed
	fmt.printfln("Move: %v", move)
	fmt.printfln("Vel: %v", world.entities[0].velocity)

	if move.y == -1 && world.entities[0].velocity.y > 0 {
		world.entities[0].velocity.y = -350
	}

	entities_aabbs := [dynamic]int{}
	for &entity in world.entities {
		physics.apply_gravity_entity(&entity, frame_time)
		e.entity_move(&entity, world, frame_time)
		fmt.printfln("Entity: %v", entity)

		// NOTE: Just mapping entities AABBs
		append(&entities_aabbs, int(entity.aabb))
	}

	/*
	for &aabb, i in world.aabbs {
		if slice.contains(entities_aabbs[:], i) {
			continue
		}

		physics.apply_gravity_aabb(&aabb, frame_time, world.aabbs[:], world.floor.top)

		height := c.aabb_height(aabb)
		aabb.bottom = min(world.floor.top, aabb.bottom)
		aabb.top = aabb.bottom - height
	}
	*/
}

get_scene :: proc() -> ex.Scene {
	return ex.Scene{
		init=init,
		deinit=deinit,
		render=render,
		update_loop=update_loop,
	}
}
