package main

import log    "core:log"
import carton "../the-carton"

main :: proc() {
	context.logger = log.create_console_logger()
	carton.init_window(1600, 900, "Project Lilypad", .OpenGL)

	mesh := carton.register_mesh("./assets/models/SM_Boat01.fbx")
	entity := carton.Entity {
		position = {0, 0, 0},
		mesh = &mesh,
	}

	for !carton.should_close_window() {
		carton.update_window(&entity)
		entity.position.z += 0.001
	}

	carton.destroy_window()
}
