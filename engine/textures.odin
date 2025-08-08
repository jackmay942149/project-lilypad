package engine

import gl "vendor:OpenGL"
import stbi "vendor:stb/image"

texture_load :: proc(filepath: cstring) -> (texture_id: u32){
	x, y, comp : i32
	data := stbi.load(filepath, &x, &y, &comp, 0)
	gl.GenTextures(1, &texture_id)
	gl.BindTexture(gl.TEXTURE_2D, texture_id)

	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
	
	gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGB, x, y, 0, gl.RGB, gl.UNSIGNED_BYTE, data)
	gl.GenerateMipmap(gl.TEXTURE_2D)
	defer stbi.image_free(data)
	return texture_id
}
