package engine

import gl "vendor:OpenGL"
import stbi "vendor:stb/image"

@(require_results)
texture_load :: proc(filepath: cstring, position: u32, shader_id: u32) -> (texture_id: u32){
	x, y, comp : i32
	data := stbi.load(filepath, &x, &y, &comp, 0)
	assert(data != nil)
	gl.GenTextures(1, &texture_id)
	gl.UseProgram(shader_id)
	gl.ActiveTexture(gl.TEXTURE0 + position)
	gl.BindTexture(gl.TEXTURE_2D, texture_id)

	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
	
	gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGB, x, y, 0, gl.RGB, gl.UNSIGNED_BYTE, data)
	gl.GenerateMipmap(gl.TEXTURE_2D)

	if position == 0 {
		loc := gl.GetUniformLocation(shader_id, "u_texture_1")
		gl.Uniform1i(gl.GetUniformLocation(shader_id, "u_texture_1"), 0)
	} else if position == 1 {
		loc := gl.GetUniformLocation(shader_id, "u_texture_2")
		gl.Uniform1i(gl.GetUniformLocation(shader_id, "u_texture_2"), 1) // FIX: Error use 1 maybe
	}
	defer stbi.image_free(data)
	return
}
