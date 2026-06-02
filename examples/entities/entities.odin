package entities

import "core:fmt"
import "core:log"
import rl "vendor:raylib"
import c "../../src/collision"
import e "../../src/entity"
import ex ".."
import r "../../src/render"
import "../../src/physics"

world := e.World{}
FLOOR_HEIGHT :: 48

@(private="file")
init :: proc(window: r.Window) {
	append(&world.entities, e.Entity{
		aabb = c.AABB{
			left = 0,
			right = 32,
			top = 0,
			bottom = 32,
		},
		velocity = {0, 0},
		speed = 42,
	})

	append(&world.aabbs, c.AABB{
		left = 50,
		right = 82,
		top = 0,
		bottom = 32,
	})

	world.floor = {
		left = 0,
		right = f32(window.width),
		top = f32(window.height - FLOOR_HEIGHT),
		bottom = f32(window.height),
	}
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

	for entity in world.entities {
		r.render_aabb(entity.aabb, rl.BLUE)
	}

	for aabb in world.aabbs {
		r.render_aabb(aabb, rl.RED)
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

	for &entity in world.entities {
		// TODO: Use velocty instead apply gravity
		physics.apply_gravity_aabb(
			&entity.aabb, frame_time, world.aabbs[:], world.floor.top)
	}

	for &aabb in world.aabbs {
		physics.apply_gravity_aabb(&aabb, frame_time, world.aabbs[:], world.floor.top)

		height := c.aabb_height(aabb)
		aabb.bottom = min(world.floor.top, aabb.bottom)
		aabb.top = aabb.bottom - height
	}
}

get_scene :: proc() -> ex.Scene {
	return ex.Scene{
		init=init,
		deinit=deinit,
		render=render,
		update_loop=update_loop,
	}
}
