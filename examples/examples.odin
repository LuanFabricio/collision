package examples

import "../src/render"

Scene :: struct {
	init: proc(window: render.Window),
	deinit: proc(),
	update_loop: proc(frame_time: f32),
	render: proc(window: render.Window),
}
