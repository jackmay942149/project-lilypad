package main

main :: proc() {
	window_init(800, 680, "Vulkan")

	for !window_should_close() {
		window_update()
	}

	window_destroy()
}
