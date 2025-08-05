package engine

import gl "vendor:OpenGL"

Mesh :: struct {
	registered: bool,
	streamed  : bool,
	vao       : u32,
	vertices  : []Vertex,
	indicies  : []u32,
}

Vertex :: struct {
	position: [3]f32,
	color   : [4]f32,
}

register_mesh :: proc(mesh: ^Mesh, streamed := false) {
	assert(mesh != nil)
	if mesh.registered {
		return
	}

	vbo, ebo: u32 
	gl.GenVertexArrays(1, &mesh.vao)
	gl.GenBuffers(1, &vbo)
	gl.GenBuffers(1, &ebo)
	gl.BindVertexArray(mesh.vao)

	if (!streamed) {
		gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
		gl.BufferData(gl.ARRAY_BUFFER, size_of(Vertex) * len(mesh.vertices), raw_data(mesh.vertices), gl.DYNAMIC_DRAW)
	} else {
		gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
		gl.BufferData(gl.ARRAY_BUFFER, size_of(Vertex) * len(mesh.vertices), raw_data(mesh.vertices), gl.DYNAMIC_DRAW)
	}


	gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo)
	gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, size_of(mesh.indicies[0]) * len(mesh.indicies), raw_data(mesh.indicies), gl.DYNAMIC_DRAW)
	
	gl.EnableVertexAttribArray(0)
	gl.VertexAttribPointer(0, 3, gl.FLOAT, false, size_of(Vertex), offset_of(Vertex, position))
	gl.EnableVertexAttribArray(1)
	gl.VertexAttribPointer(1, 4, gl.FLOAT, false, size_of(Vertex), offset_of(Vertex, color))
	gl.BindVertexArray(0)

	mesh.registered = true
}
