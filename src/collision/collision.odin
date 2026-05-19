package collision

import rl "vendor:raylib"

Point :: struct {
	x, y: i32
}

vector2_to_point :: proc(vec: rl.Vector2) -> Point {
	return Point{
		x = i32(vec[0]),
		y = i32(vec[1]),
	}
}
