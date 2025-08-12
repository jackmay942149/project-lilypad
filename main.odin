package main

import "./engine"
import "./scripts"

app_info :: engine.Application {
	name = "Project Lilypad",
	width = 1600,
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
hex_mesh := engine.mesh_load("./assets/models/SM_HexGrid_01.fbx")
lilypad_mesh := engine.mesh_load("./assets/models/SM_Lilypad_LowPoly01.fbx")

// Entities
boat := engine.Entity {
	position = {0.0, 0.0},
	mesh = &boat_mesh,
	tag = .Boat,
	update = scripts.boat_update,
}
ocean := engine.Entity {
	position = {0.0, 0.0},
	mesh = &ocean_mesh,
	tag = .Ocean,
	update = scripts.ocean_update,
}
lilypad := engine.Entity {
	position = {0.0, 0.5},
	mesh = &lilypad_mesh,
	tag = .Lilypad,
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

	// Register Meshes
	engine.mesh_register(&boat_mesh)
	engine.mesh_register(&ocean_mesh, true)
	engine.mesh_register(&lilypad_mesh)

	// Setup Scene
	scene := engine.Scene {
		entities = {ocean, boat, lilypad},
	}

	// Load Shaders
	ocean.mesh.material.shader_program = engine.material_load("./assets/shaders/default.vert", "./assets/shaders/ocean.frag")
	boat.mesh.material.shader_program = engine.material_load("./assets/shaders/default.vert", "./assets/shaders/boat.frag")
	lilypad.mesh.material.shader_program = engine.material_load("./assets/shaders/default.vert", "./assets/shaders/boat.frag")

	// Set Textures
	ocean.mesh.material.texture_ids.x = engine.texture_load("./assets/textures/moss/DIFF_MossColour01.JPG",  1, ocean.mesh.material.shader_program)
	ocean.mesh.material.texture_ids.y = engine.texture_load("./assets/textures/water/MASK_Water_02.JPG",  0, ocean.mesh.material.shader_program)

	for !engine.window_should_close(window) {
		engine.window_render(window, scene)
		engine.scene_update_entities(&scene)
	}
}


