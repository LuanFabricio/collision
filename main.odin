package main

import rl "vendor:raylib"
import "core:fmt"

import "src/render"

import "examples"
import "examples/boxes"
import "examples/entities"

WINDOW_WIDTH :: 720
WINDOW_HEIGHT :: 480
WINDOW_TITLE :: "Collision"

main :: proc() {
	fmt.println("Hello, world!")

	scene: examples.Scene = boxes.get_scene()
	scene = entities.get_scene()
	window := render.Window{
		width = WINDOW_WIDTH,
		height = WINDOW_HEIGHT,
		title = WINDOW_TITLE
	}

	render.init_window(window)
	scene.init(window)

	for !render.should_close() {
		scene.render(window)
		scene.update_loop(rl.GetFrameTime())
	}
}
