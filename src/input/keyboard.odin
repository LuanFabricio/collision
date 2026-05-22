package input

import rl "vendor:raylib"

KEY_MOVE_UP :: rl.KeyboardKey.W
KEY_MOVE_DOWN :: rl.KeyboardKey.S
KEY_MOVE_LEFT :: rl.KeyboardKey.A
KEY_MOVE_RIGHT :: rl.KeyboardKey.D

input_get_move_vector2 :: proc() -> rl.Vector2 {
	move_vector := rl.Vector2(0)

	move_map := make(map[rl.KeyboardKey]rl.Vector2)
	move_map[KEY_MOVE_DOWN] = rl.Vector2({0, 1})
	move_map[KEY_MOVE_UP] = rl.Vector2({0, -1})
	move_map[KEY_MOVE_LEFT] = rl.Vector2({-1, 0})
	move_map[KEY_MOVE_RIGHT] = rl.Vector2({1, 0})

	for key, move in move_map {
 		if rl.IsKeyDown(key) {
			move_vector += move
		}
	}

	return rl.Vector2Normalize(move_vector)
}
