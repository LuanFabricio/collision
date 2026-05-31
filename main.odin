package main

import rl "vendor:raylib"
import "core:fmt"

import "src/container"
import "src/render"

import "examples"
import "examples/boxes"

WINDOW_WIDTH :: 720
WINDOW_HEIGHT :: 480
WINDOW_TITLE :: "Collision"

main :: proc() {
	fmt.println("Hello, world!")

	scene: examples.Scene = boxes.get_scene()
	window := render.Window{
		width = WINDOW_WIDTH,
		height = WINDOW_HEIGHT,
		title = WINDOW_TITLE
	}

	render.init_window(window)
	scene.init(window)

	fmt.printfln("%v", boxes.cont.aabb_items[len(boxes.cont.aabb_items)-1])

	for !render.should_close() {
		scene.render(window)
		scene.update_loop(rl.GetFrameTime())

		// aabb_items_len := len(boxes.cont.aabb_items)
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
