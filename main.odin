package main

import rl "vendor:raylib"
import "core:fmt"

import "src/collision"


WINDOW_WIDTH :: 720
WINDOW_HEIGHT :: 480
WINDOW_TITLE :: "Collision"

Container :: struct {
	aabb_items: [dynamic]collision.AABB,
	aabb_colors: [dynamic]rl.Color,
	selected_item: ^collision.AABB
}

container_append_aabb :: proc(
	container: ^Container,
	aabb: collision.AABB,
	color: rl.Color = rl.RED
) {
	append(&container.aabb_items, aabb)
	append(&container.aabb_colors, color)
}

main :: proc() {
	fmt.println("Hello, world!")

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)

	container := Container{
		selected_item = nil,
	}
	container_append_aabb(
		&container,
		collision.AABB{
			left = 42,
			right = 42*4,
			top = 42,
			bottom = 42*4,
		},
		rl.BLUE,
	)

	container_append_aabb(
		&container,
		collision.AABB{
			left = 0,
			right = 42*3,
			top = 0,
			bottom = 42*3,
		},
		rl.RED
	)

	for !rl.WindowShouldClose() {
		draw(container)
		update_loop(&container)

		aabb_items_len := len(container.aabb_items)
		for aabb1, i in container.aabb_items {
			for j in i+1..<aabb_items_len {
				aabb2 := container.aabb_items[j]
				if (collision.aabb_check(aabb1, aabb2)) {
					fmt.printf("Colliding between idxs %d and %d\n", i, j)
				}
			}
		}
	}
}

draw :: proc(container: Container) {
	rl.BeginDrawing()

	rl.ClearBackground(rl.BLACK)

	for aabb, i in container.aabb_items {
		color := container.aabb_colors[i]
		collision.draw_aabb(aabb, color)
	}

	rl.EndDrawing()
}

update_loop :: proc(container: ^Container) {
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
		// collision.aabb_update_position(container.selected_item, mouse)
		collision.aabb_update_position_with_collision(container.selected_item, mouse, container.aabb_items[:])
	}
}
