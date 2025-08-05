package main

import la "core:math/linalg"

import "./engine"

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

// Entities
boat1 := engine.Entity {
	position = {0.0, 0.0},
	mesh = &boat_mesh,
}
ocean := engine.Entity {
	position = {0.0, 0.0},
	mesh = &ocean_mesh,
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

	engine.register_mesh(&boat_mesh)
	engine.register_mesh(&ocean_mesh)

	scene := engine.Scene {
		entities = {&ocean, &boat1,},
	}
	
	ocean.mesh.vertices[0].color = {0.0, 0.0, 0.0, 1.0}

	for !engine.window_should_close(window) {
		engine.render(window, scene)
		for &v in ocean.mesh.vertices {
			amount := v.color.r
			amount += 0.0001
			amount = min(amount, 1.0)
			if la.distance(v.position.xy, boat1.position) < 0.1 {
				amount = 0
			}
			v.color = {amount, amount, amount, 1.0}
		}

		if engine.is_key_down(window, .W) {
			boat1.position.y += 0.001
		}
		if engine.is_key_down(window, .S) {
			boat1.position.y -= 0.001
		}
		if engine.is_key_down(window, .A) {
			boat1.position.x -= 0.001
		}
		if engine.is_key_down(window, .D) {
			boat1.position.x += 0.001
		}
	}

}
