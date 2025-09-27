package main

import "engine"
import "core:log"

main :: proc() {
	context.logger = log.create_console_logger()
	engine.init_window(800, 680, "Project Lilypad", .OpenGL)

	mesh := engine.register_mesh()

	for !engine.should_close_window() {
		engine.update_window(&mesh)
	}

	engine.destroy_window()
}
