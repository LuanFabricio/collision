package topdown

import "core:slice"
import "core:fmt"
import rl "vendor:raylib"
import c "../../src/collision"
import e "../../src/entity"
import "../../src/input"
import ex ".."
import r "../../src/render"

world := e.World{}
FLOOR_HEIGHT :: 48

@(private="file")
init :: proc(window: r.Window) {
	e.world_add_entity(
		&world,
		e.Entity{
			aabb = 0,
			velocity = {0, 0},
			speed = 100,
		},
		c.AABB{
			left = 0,
			right = 32,
			top = 0,
			bottom = 32,
		},
		rl.Color{0xff, 0xff, 0xff, 0xff},
	)

	for i in 0..<3 {
		i := f32(i)
		for j in 0..<3 {
			j := f32(j)
			append(&world.aabbs,
				c.AABB{
					top = 50 + 32 * j,
					bottom = 82 + 32 * j,
					left = 50 + 32 * i,
					right = 82 + 32 * i,
				},
			)

			append(&world.aabbs,
				c.AABB{
					top = 50 + 32 * j,
					bottom = 82 + 32 * j,
					left = f32(window.width) - 18 - 32 * (i + 2),
					right = f32(window.width) - 18 - 32 * (i + 1),
				},
			)
		}
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
	world.entities[0].velocity = move * world.entities[0].speed
	fmt.printfln("Move: %v", move)
	fmt.printfln("Vel: %v", world.entities[0].velocity)

	entities_aabbs := [dynamic]int{}
	for &entity, i in world.entities {
		e.entity_move(&entity, world, frame_time, false)
		fmt.printfln("Entity: %v", entity)
		fmt.printfln("AABB: %v", world.aabbs[i])
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
