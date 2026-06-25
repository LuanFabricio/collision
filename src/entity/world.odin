package entity;

import rl "vendor:raylib"

import "../collision"

World :: struct {
	entities: [dynamic]Entity,
	aabbs: [dynamic]collision.AABB,
	colors: [dynamic]rl.Color,
	floor: collision.AABB,
}

world_add_entity :: proc(world: ^World, entity: Entity, aabb: collision.AABB, color: rl.Color) {
	append(&world.aabbs, aabb)
	append(&world.colors, color)

	entity := entity
	entity.aabb = i32(len(world.aabbs) - 1)
	entity.color = i32(len(world.colors) - 1)
	append(&world.entities, entity)
}
