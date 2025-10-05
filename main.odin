package main

import log    "core:log"
import carton "../the-carton"

boat := #load("assets/models/SM_Boat02.fbx")
hex := #load("assets/models/SM_HexGrid_01.fbx")
moss := #load("assets/textures/debug/uv.jpg")

main :: proc() {
	context.logger = log.create_console_logger()
	carton.init_window(1600, 900, "Project Lilypad", .OpenGL)

	boat_mesh := carton.register_mesh(boat)
	hex_mesh := carton.register_mesh(hex)
	shader := carton.register_shader("assets/shaders/default.vert", "assets/shaders/normal.frag")
	texture := carton.register_texture(moss)


	carton.attach_shader_to_material(&boat_mesh.material, shader)
	carton.attach_texture_to_material(&boat_mesh.material, texture)
	carton.attach_shader_to_material(&hex_mesh.material, shader)
	carton.attach_texture_to_material(&hex_mesh.material, texture)
	
	entity := carton.Entity {
		position = {0, 0, 0},
		mesh = &boat_mesh,
	}

	hex_entity := carton.Entity {
		position = {0, -2, 0},
		mesh = &hex_mesh,
	}
	hex_entity_2 := carton.Entity {
		position = {2*7.5, -2, 8.66},
		mesh = &hex_mesh,
	}

	scene := carton.Scene {
		entities = {
			entity,
			hex_entity,
			hex_entity_2,
		}
	}

	for !carton.should_close_window() {
		carton.update_window(&scene)
	}

	carton.destroy_window()
}
