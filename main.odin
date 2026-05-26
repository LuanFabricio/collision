package main

import rl "vendor:raylib"
import "core:fmt"

import "src/collision"
import "src/container"
import "src/physics"
import "src/input"
import "src/render"

WINDOW_WIDTH :: 720
WINDOW_HEIGHT :: 480
WINDOW_TITLE :: "Collision"

main :: proc() {
	fmt.println("Hello, world!")

	window := render.Window{
		width = WINDOW_WIDTH,
		height = WINDOW_HEIGHT,
		title = WINDOW_TITLE
	}

	render.init_window(window)

	cont := container.Container{
		selected_item = nil,
	}

	container.container_append_aabb(
		&cont,
		collision.AABB{
			left = 32 * 2,
			right = f32(window.width) - 32 * 2,
			top = f32(window.height) - 32,
			bottom = f32(window.height)
		},
		rl.GREEN,
	)

	container.container_append_aabb(
		&cont,
		collision.AABB{
			left = f32(window.width) - 42 * 4,
			right = f32(window.width),
			top = f32(window.height) - 42 * 4,
			bottom = f32(window.height),
		},
		rl.BLUE,
	)

	container.container_append_aabb(
		&cont,
		collision.AABB{
			left = 0,
			right = 42*3,
			top = 0,
			bottom = 42*3,
		},
		rl.RED
	)
	fmt.printfln("%v", cont.aabb_items[len(cont.aabb_items)-1])

	for !render.should_close() {
		render.render(window, cont)
		update_loop(&cont, rl.GetFrameTime())

		aabb_items_len := len(cont.aabb_items)
		// for aabb1, i in cont.aabb_items {
		// 	for j in i+1..<aabb_items_len {
		// 		aabb2 := cont.aabb_items[j]
		// 		if (collision.aabb_check(aabb1, aabb2)) {
		// 			fmt.printf("Colliding between idxs %d and %d\n", i, j)
		// 		}
		// 	}
		// }
	}
}

update_loop :: proc(cont: ^container.Container, frame_time: f32) {
	mouse := input.get_mouse_position_as_point()
	if (input.is_mouse_button_pressed(rl.MouseButton.LEFT)) {
		if (cont.selected_item == nil) {
			for &aabb in cont.aabb_items {
				if (collision.aabb_check_point(aabb, mouse)) {
					cont.selected_item = &aabb
					break
				}
			}
		} else {
			cont.selected_item = nil
		}
	}

	move_vector := input.input_get_move_vector2()
	if (cont.selected_item != nil && (move_vector.x != 0 || move_vector.y != 0)) {
		item := cont.selected_item
		w := collision.aabb_width(item^)
		h := collision.aabb_height(item^)
		OBJECT_SPEED :: 320
		move_vector *= OBJECT_SPEED
		move_vec := rl.Vector2({
			f32(item.left + w / 2),
			f32(item.top + h / 2)
		}) +  move_vector * rl.GetFrameTime()
		collision.aabb_update_position_with_collision(
			item,
			collision.vector2_to_point(move_vec),
			cont.aabb_items[:]
		)
	}
	for &aabb in cont.aabb_items {
		physics.apply_gravity_aabb(&aabb, frame_time, cont.aabb_items[:])
	}
}
