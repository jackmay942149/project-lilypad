package engine

import "vendor:glfw"
import gl "vendor:OpenGL"

Window :: struct {
	handle    : glfw.WindowHandle,
	gl_ctx: OpenGL_Context,
}

OpenGL_Context :: struct {
	shader_program: u32,
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

	ok: bool
	window.gl_ctx.shader_program, ok = gl.load_shaders_file(
		"assets/shaders/default.vert",
		"assets/shaders/default.frag",
	)
	if !ok {
		topic_warn(.Engine, "Failed to compile shaders")
	}

	return window
}

window_should_close :: proc(window: Window) -> (should_close: bool) {
	should_close = bool(glfw.WindowShouldClose(window.handle))
	return should_close
}

render :: proc(window: Window, scene: Scene) {
	glfw.PollEvents()
	gl.ClearColor(0.5, 0.0, 1.0, 1.0)
	gl.Clear(gl.COLOR_BUFFER_BIT)

	gl.UseProgram(window.gl_ctx.shader_program)
	for e in scene.entities {
		gl.BindVertexArray(e.mesh.vao)
		// Set 2D position
		pos_location := gl.GetUniformLocation(window.gl_ctx.shader_program, "u_pos")
		gl.Uniform2f(pos_location, e.position.x, e.position.y)

		// Set texture
		if e.mesh.texture_id != 0 {
			gl.BindTexture(gl.TEXTURE_2D, e.mesh.texture_id)		
		}

		if e.mesh.streamed {
			gl.BufferSubData(gl.ARRAY_BUFFER, 0, size_of(Vertex) * len(e.mesh.vertices), raw_data(e.mesh.vertices[:]))
		}
		gl.DrawElements(gl.TRIANGLES, i32(len(e.mesh.indicies)), gl.UNSIGNED_INT, nil)
	}
	
	glfw.SwapBuffers(window.handle)
}

