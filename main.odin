package main

import "./engine"
import "./scripts"

app_info :: engine.Application {
	name = "Project Lilypad",
	width = 900,
	height = 900,
	gl_major_version = 3,
	gl_minor_version = 3,
}

//  Meshes
boat_mesh := engine.Mesh {
	vertices = {
	  {position = {-0.05, -0.05, 0.0,}, color = {1.0, 0.0, 0.0, 1.0,}},
	  {position = { 0.05, -0.05, 0.0,}, color = {1.0, 0.0, 0.0, 1.0,}},
	  {position = { 0.00,  0.05, 0.0,}, color = {1.0, 0.0, 0.0, 1.0,}},
	},
	indicies = {0, 1, 2}
}
ocean_mesh := engine.ocean

// Entities
boat := engine.Entity {
	position = {0.0, 0.0},
	mesh = &boat_mesh,
	tag = .Boat,
	update = scripts.boat_update,
	collision_radius = 0.1,
}
ocean := engine.Entity {
	position = {0.0, 0.0},
	mesh = &ocean_mesh,
	tag = .Ocean,
	update = scripts.ocean_update,
}


main :: proc() {
	context.logger = engine.logger_init(.Jack, .All)	
	tracking_allocator, allocator := engine.tracker_init()
	context.allocator = allocator
	defer {
		engine.tracker_assert_empty(tracking_allocator)
		engine.tracker_destroy(tracking_allocator)
	}

	window := engine.window_init(app_info)
	engine.input_init(window.handle)

	// Load meshes
	hex_mesh := engine.mesh_load("./assets/models/SM_HexGrid_01.fbx", 100.0)
	hex_2_mesh := engine.mesh_load("./assets/models/SM_HexGrid_01.fbx", 100.0)
	lilypad_mesh := engine.mesh_load("./assets/models/SM_Lilypad_LowPoly01.fbx", 10.0)
	

	// Create Entities
	lilypad := engine.Entity {
		position = {0.0, 0.5},
		mesh = &lilypad_mesh,
		tag = .Lilypad,
		collision_radius = 0.01,
		collision_during = scripts.lilypad_collision_during,
	}
	hex := engine.Entity {
		position = {0.0, 0.0},
		mesh = &hex_mesh,
		tag = .Hex,
	}
	hex_2 := engine.Entity {
		position = {0.15, 0.0866},
		mesh = &hex_2_mesh,
		tag = .Hex,
	}

	// Register Meshes
	boat.material = engine.mesh_register(&boat_mesh)
	ocean.material = engine.mesh_register(&ocean_mesh, true)
	lilypad.material = engine.mesh_register(&lilypad_mesh)
	hex.material = engine.mesh_register(&hex_mesh)
	hex_2.material = engine.mesh_register(&hex_2_mesh)

	// Get uids
	boat.id = engine.scene_get_uid()
	ocean.id = engine.scene_get_uid()
	lilypad.id = engine.scene_get_uid()
	hex.id = engine.scene_get_uid()
	hex_2.id = engine.scene_get_uid()


	// Load Shaders
	ocean.material.shader_program   = engine.material_load("./assets/shaders/default.vert", "./assets/shaders/ocean.frag")
	boat.material.shader_program    = engine.material_load("./assets/shaders/default.vert", "./assets/shaders/boat.frag")
	lilypad.material.shader_program = engine.material_load("./assets/shaders/default.vert", "./assets/shaders/boat.frag")
	hex.material.shader_program     = engine.material_load("./assets/shaders/default.vert", "./assets/shaders/ocean.frag")
	hex_2.material = hex.material

	// Setup Scene
	scene := engine.Scene {
		entities = {ocean, lilypad, hex, hex_2, boat},
	}

	// Set Textures
	ocean.material.texture_ids.x = engine.texture_load("./assets/textures/moss/DIFF_MossColour01.JPG",  0, ocean.material.shader_program)
	ocean.material.texture_ids.y = engine.texture_load("./assets/textures/water/MASK_Water_02.JPG",  1, ocean.material.shader_program)

	hex.material.texture_ids.x = engine.texture_load("./assets/textures/moss/DIFF_MossColour01.JPG",  0, ocean.material.shader_program)
	hex.material.texture_ids.y = engine.texture_load("./assets/textures/water/MASK_Water_02.JPG",  1, ocean.material.shader_program)

	for !engine.window_should_close(&window) {
		engine.window_render(&window, &scene)
		engine.scene_update_entities(&scene)
		engine.physics_update(&scene)
	}
}


