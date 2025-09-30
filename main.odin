package main

import "../engine"
import "core:log"

main :: proc() {
	context.logger = log.create_console_logger()
	engine.init_window(1600, 900, "Project Lilypad", .OpenGL)

	mesh := engine.register_mesh("../engine/models/boat.fbx")
	entity := engine.Entity {
		position = {0, 0, 0},
		mesh = &mesh,
	}

	for !engine.should_close_window() {
		engine.update_window(&entity)
		entity.position.z += 0.001
	}

	engine.destroy_window()
}
