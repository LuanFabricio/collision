package input

import rl "vendor:raylib"

import "../collision"

get_mouse_position_as_point :: proc() -> collision.Point {
	return collision.vector2_to_point(rl.GetMousePosition())
}

is_mouse_button_pressed :: proc(button: rl.MouseButton) -> bool {
	return rl.IsMouseButtonPressed(button)
}
