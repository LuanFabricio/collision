package main

import "vendor:raylib"
import "core:fmt"

import "collision"

rl :: raylib

WINDOW_WIDTH :: 960
WINDOW_HEIGHT :: 720
WINDOW_TITLE :: "Collision"

Container :: struct {
	aabb_items: [dynamic]collision.AABB,
	selected_item: ^collision.AABB
}

main :: proc() {
	fmt.println("Hello, world!")

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)

	aabb := collision.AABB{
		left = 42,
		right = 84,
		top = 42,
		bottom = 84,
	}

	drag_item: ^collision.AABB = nil

	container := Container{
		selected_item = nil,
	}
	append(&container.aabb_items, collision.AABB{
		left = 42,
		right = 84,
		top = 42,
		bottom = 84,
	})

	for !rl.WindowShouldClose() {
		draw(container)

		mouse := collision.vector2_to_point(rl.GetMousePosition())
		if (rl.IsMouseButtonPressed(rl.MouseButton.LEFT)) {
			if (container.selected_item == nil) {
				for &aabb in container.aabb_items {
					if (collision.aabb_check_point(aabb, mouse)) {
						container.selected_item = &aabb
						break
					}
				}
			} else {
				container.selected_item = nil
			}
		}

		if (container.selected_item != nil) {
			collision.aabb_update_position(container.selected_item, mouse)
		}
	}
}

draw :: proc(container: Container) {
	rl.BeginDrawing()

	rl.ClearBackground(rl.BLACK)

	for aabb in container.aabb_items {
		collision.draw_aabb(aabb, rl.BLUE)
	}

	rl.EndDrawing()
}
