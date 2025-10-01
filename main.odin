package main

import log    "core:log"
import carton "../the-carton"

main :: proc() {
	context.logger = log.create_console_logger()
	carton.init_window(1600, 900, "Project Lilypad", .OpenGL)

	mesh := carton.register_mesh("assets/models/SM_Boat01.fbx")
	shader := carton.register_shader("assets/shaders/default.vert", "assets/shaders/default.frag")
	texture := carton.register_texture("assets/textures/moss/DIFF_MossColour01.JPG")

	carton.attach_shader_to_material(&mesh.material, shader)
	carton.attach_texture_to_material(&mesh.material, texture)
	
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
