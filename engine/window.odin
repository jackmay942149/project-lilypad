package engine

import "vendor:glfw"
import gl "vendor:OpenGL"

Window :: struct {
	handle: glfw.WindowHandle,
}

@(require_results)
init_window :: proc(app_info: Application_Info) -> (window: Window) {
	if !bool(glfw.Init()) {
		topic_warn(.Engine, "GLFW has failed to load")
		return
	}

	window.handle = glfw.CreateWindow(app_info.width, app_info.height, app_info.name, nil, nil)
	if window.handle == nil {
		topic_warn(.Engine, "GLFW has failed to load the window")
		return
	}

	glfw.MakeContextCurrent(window.handle)
	gl.load_up_to(app_info.gl_major_version, app_info.gl_minor_version, glfw.gl_set_proc_address)
	return window
}

window_should_close :: proc(window: Window) -> (should_close: bool) {
	should_close = bool(glfw.WindowShouldClose(window.handle))
	return should_close
}

render :: proc(window: Window) {
	glfw.PollEvents()
	gl.ClearColor(0.5, 0.0, 1.0, 1.0)
	gl.Clear(gl.COLOR_BUFFER_BIT)
	glfw.SwapBuffers(window.handle)
}

