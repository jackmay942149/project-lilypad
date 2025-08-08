package engine

import "vendor:glfw"

Entity :: struct {
	position: [2]f32,
	mesh    : ^Mesh,
	tag     : Entity_Tag,
	update  : proc(^Scene, ^Entity),

	// Ocean variables
	boat_pos:              [2]f32,
	moss_regrow_rate:      f32,
	moss_removal_distance: f32,

	// Boat variables
	window: Window, // For input TODO: Refactor
}

Entity_Tag :: enum {
	Boat,
	Ocean,
}

update_components :: proc(scene: ^Scene) {
	for &e in scene.entities {
		if e.update != nil {
			e.update(scene, &e)
		}
	}
}
