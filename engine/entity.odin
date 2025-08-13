package engine

import "vendor:glfw"

Entity :: struct {
	id:               int,
	position:         [2]f32,
	mesh:             ^Mesh,
	tag:              Entity_Tag,
	collision_radius: f32,
	update:           proc(^Scene, ^Entity),
	collision_start:  proc(^Entity, ^Entity),
	collision_during: proc(^Entity, ^Entity),
	collision_end:    proc(^Entity, ^Entity),
}

Entity_Tag :: enum {
	Boat,
	Ocean,
	Lilypad,
}

