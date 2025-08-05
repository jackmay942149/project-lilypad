package main

import "./engine"

app_info :: engine.Application_Info {
	name = "Project Lilypad",
	width = 1600,
	height = 900,
	gl_major_version = 3,
	gl_minor_version = 3,
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

	for !engine.window_should_close(window) {
		engine.render(window)
	}
}
