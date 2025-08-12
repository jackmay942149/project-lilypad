package engine

import gl "vendor:OpenGL"

Material :: struct {
	shader_program: u32,
	vao:            u32,
	vbo:            u32,
	texture_ids:    [2]u32,
}

@(require_results)
material_load :: proc(vert_filepath, frag_filepath: string) -> (shader_id: u32) {
	ok: bool
	shader_id, ok = gl.load_shaders_file(vert_filepath, frag_filepath)
	if !ok {
		topic_warn(.Engine, "Failed to compile shaders")
	}
	return shader_id
}
