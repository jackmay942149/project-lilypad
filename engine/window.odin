package engine

import "vendor:glfw"
import gl "vendor:OpenGL"

Window :: struct {
	handle    : glfw.WindowHandle,
}

@(require_results)
window_init :: proc(app_info: Application) -> (window: Window) {
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
	glfw.SwapInterval(1)
	gl.load_up_to(app_info.gl_major_version, app_info.gl_minor_version, glfw.gl_set_proc_address)

	return window
}

@(private = "file") escape_key :: Input_Key{.Escape, {}, .Press}
window_should_close :: proc(window: ^Window) -> (should_close: bool) {
	should_close = bool(glfw.WindowShouldClose(window.handle))
	if is_key_down(escape_key) {
		should_close = true
	}
	return should_close
}

window_render :: proc(window: ^Window, scene: ^Scene) {
	glfw.PollEvents()
	gl.ClearColor(0.5, 0.0, 1.0, 1.0)
	gl.Clear(gl.COLOR_BUFFER_BIT)

	for e in scene.entities {
		gl.UseProgram(e.mesh.material.shader_program)
		gl.BindVertexArray(e.mesh.material.vao)
		// Set 2D position
		pos_location := gl.GetUniformLocation(e.mesh.material.shader_program, "u_pos")
		gl.Uniform2f(pos_location, e.position.x, e.position.y)

		// Set texture
		if e.mesh.material.texture_ids[0] != 0 {
			gl.ActiveTexture(gl.TEXTURE0)
			gl.BindTexture(gl.TEXTURE_2D, e.mesh.material.texture_ids.x)		
			gl.ActiveTexture(gl.TEXTURE1)
			gl.BindTexture(gl.TEXTURE_2D, e.mesh.material.texture_ids.y)		
		}

		if e.mesh.streamed {
			gl.BindBuffer(gl.ARRAY_BUFFER, e.mesh.material.vbo)
			gl.BufferSubData(gl.ARRAY_BUFFER, 0, size_of(Vertex) * len(e.mesh.vertices), raw_data(e.mesh.vertices[:]))
		}
		gl.DrawElements(gl.TRIANGLES, i32(len(e.mesh.indicies)), gl.UNSIGNED_INT, nil)
	}
	
	glfw.SwapBuffers(window.handle)
}

