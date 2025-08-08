package main

import "./engine"
import "./scripts"

app_info :: engine.Application_Info {
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
hex_mesh := engine.load_mesh("./assets/models/SM_HexGrid_01.fbx")

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

	moss_removal_distance = 0.05,
}

main :: proc() {
	context.logger = engine.init_logger(.Jack, .All)	
	tracking_allocator, allocator := engine.init_tracker()
	context.allocator = allocator
	defer {
		engine.assert_tracker_empty(tracking_allocator)
		engine.destroy_tracker(tracking_allocator)
	}

	window := engine.init_window(app_info)
	boat.window = window

	engine.register_mesh(&boat_mesh)
	engine.register_mesh(&ocean_mesh)

	scene := engine.Scene {
		entities = {ocean, boat},
	}

	ocean_mesh.texture_id = engine.texture_load("./assets/textures/moss/DIFF_MossColour01.JPG")

	for !engine.window_should_close(window) {
		engine.render(window, scene)
		engine.update_components(&scene)
	}

}
