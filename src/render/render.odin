package render

import "core:strings"

import rl "vendor:raylib"

import "../collision"
import "../container"

Container :: container.Container

Window :: struct {
	width, height: i32,
	title: string,
}

init_window :: proc(window: Window) {
	c_title := strings.clone_to_cstring(window.title, context.temp_allocator)
	rl.InitWindow(window.width, window.height, c_title)
	rl.SetTargetFPS(60)
}

render :: proc(window: Window, container: Container) {
	assert(len(container.aabb_colors) == len(container.aabb_items))

	rl.BeginDrawing()

	rl.ClearBackground(rl.BLACK)

	for aabb, i in container.aabb_items {
		render_aabb(aabb, container.aabb_colors[i])
	}

	rl.EndDrawing()
}

render_aabb :: proc(aabb: collision.AABB, color: rl.Color) {
	width := collision.aabb_width(aabb)
	height := collision.aabb_height(aabb)

	assert(width > 0)
	assert(height > 0)

	rl.DrawRectangle(
		i32(aabb.left),
		i32(aabb.top),
		i32(width),
		i32(height),
		color
	)
}

should_close :: proc() -> bool { return rl.WindowShouldClose() }
