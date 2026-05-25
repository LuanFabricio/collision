package container

import "../collision"
import rl "vendor:raylib"

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
