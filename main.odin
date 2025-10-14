package main

import log     "core:log"
import carton  "../the-carton"
import scripts " ./scripts"

boat := #load("assets/models/SM_Boat02.fbx")
hex := #load("assets/models/SM_HexGrid_01.fbx")
moss := #load("assets/textures/debug/uv.jpg")

main :: proc() {
	context.logger = log.create_console_logger()

	carton.update_label("./labels/camera.label", "./sheet-ids/auth.key")
	camera_label := carton.load_label("./labels/camera.label")
	
	carton.init_window(1600, 900, "Project Lilypad", .OpenGL)

	boat_mesh := carton.register_mesh(boat)
	hex_mesh_1 := carton.register_mesh(hex)
	hex_mesh_2 := carton.register_mesh(hex)

	boat_shader := carton.register_shader("assets/shaders/default.vert", "assets/shaders/default.frag")
	boat_texture := carton.register_texture(moss)

	hex_shader := carton.register_shader("assets/shaders/default.vert", "assets/shaders/vertex-colour.frag")

	carton.attach_shader_to_material(&boat_mesh.material, boat_shader)
	carton.attach_texture_to_material(&boat_mesh.material, boat_texture)
	carton.attach_shader_to_material(&hex_mesh_1.material, hex_shader)
	carton.attach_shader_to_material(&hex_mesh_2.material, hex_shader)
	
	entity := carton.Entity {
		position = {0, 0, 0},
		mesh = &boat_mesh,
		update = scripts.boat_update,
	}

	hex_entity := carton.Entity {
		position = {0, -2, 0},
		mesh = &hex_mesh_1,
		update = scripts.water_tile_update,
	}
	hex_entity_2 := carton.Entity {
		position = {2*7.5, -2, 8.66},
		mesh = &hex_mesh_2,
		update = scripts.water_tile_update,
	}
	hex_entity_3 := carton.Entity {
		position = {0, -2, 8.66*2},
		mesh = &hex_mesh_2,

	}

	camera_zoom, found := carton.get_label_value_int("zoom", camera_label)
	if found {
		log.info(camera_zoom)
	}
	camera_angle: int
	camera_angle, found = carton.get_label_value_int("angle", camera_label)
	if found {
		log.info(camera_zoom)
	}
	cam := carton.Camera {
		position = {0, 0, f32(-camera_zoom)},
		look_at_rotator = {f32(camera_angle), 90, 0},
		rotation_order = .YXZ,
	}

	scene := carton.Scene {
		entities = {
			entity,
			hex_entity,
			hex_entity_2,
			hex_entity_3,
		},
		camera = cam,
	}

	for !carton.should_close_window() {
		carton.update_window(&scene)
	}

	carton.destroy_window()
}
