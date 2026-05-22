package collision

import rl "vendor:raylib"

Point :: struct {
	x, y: f32
}

vector2_to_point :: proc(vec: rl.Vector2) -> Point {
	return Point{
		x = vec[0],
		y = vec[1],
	}
}
