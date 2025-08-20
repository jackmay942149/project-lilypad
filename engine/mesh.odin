package engine

import "core:fmt"
import fbx "./deps/ufbx"
import gl "vendor:OpenGL"

Mesh :: struct {
	registered: bool,
	streamed:   bool,
	vertices:   []Vertex,
	indicies:   []u32,
}

@(require_results)
mesh_load :: proc(mesh_filepath: cstring, scale_temp: f32) -> (mesh: Mesh) {
	opts := fbx.Load_Opts{}
  err := fbx.Error{}
  scene := fbx.load_file(mesh_filepath, &opts, &err)
  if scene == nil {
    fmt.printf("%s\n", err.description.data)
    panic("Failed to load")
  }

  // Retrieve the first mesh
  fbx_mesh: ^fbx.Mesh
  for i in 0 ..< scene.nodes.count {
    node := scene.nodes.data[i]
    if node.is_root || node.mesh == nil { continue }
    fbx_mesh = node.mesh
    break
  }

  // Unpack / triangulate the index data
  index_count := 3 * fbx_mesh.num_triangles
  mesh.indicies = make([]u32, index_count)
  off := u32(0)
  for i in 0 ..< fbx_mesh.faces.count {
    face := fbx_mesh.faces.data[i]
    tris := fbx.catch_triangulate_face(nil, &mesh.indicies[off], uint(index_count), fbx_mesh, face)
    off += 3 * tris
  }

  // Unpack the vertex data
  vertex_count := fbx_mesh.num_indices
  positions := make([][3]f32, vertex_count)
  mesh.vertices = make([]Vertex, vertex_count)

  for i in 0..< vertex_count {
    pos := fbx_mesh.vertex_position.values.data[fbx_mesh.vertex_position.indices.data[i]]
    coord := fbx_mesh.vertex_uv.values.data[fbx_mesh.vertex_position.indices.data[i]]
    positions[i] = {f32(pos.x)/scale_temp, f32(pos.z)/scale_temp, f32(pos.y)/scale_temp} // Set Position
    mesh.vertices[i] = Vertex{position = positions[i], color = {1.0, 1.0, 1.0, 1.0}, coords = {f32(coord.x), f32(coord.y)}} // Set Colour
  }

  // Free the fbx data
  fbx.free_scene(scene)

  return mesh
}

mesh_register :: proc(mesh: ^Mesh, streamed := false) -> (material: Material) {
	assert(mesh != nil)
	if mesh.registered {
		return
	}

	ebo: u32 
	gl.GenVertexArrays(1, &material.vao)
	gl.GenBuffers(1, &material.vbo)
	gl.GenBuffers(1, &ebo)
	gl.BindVertexArray(material.vao)

	if (!streamed) {
		gl.BindBuffer(gl.ARRAY_BUFFER, material.vbo)
		gl.BufferData(gl.ARRAY_BUFFER, size_of(Vertex) * len(mesh.vertices), raw_data(mesh.vertices), gl.DYNAMIC_DRAW)
	} else {
		gl.BindBuffer(gl.ARRAY_BUFFER, material.vbo)
		gl.BufferData(gl.ARRAY_BUFFER, size_of(Vertex) * len(mesh.vertices), raw_data(mesh.vertices), gl.DYNAMIC_DRAW)
	}


	gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo)
	gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, size_of(mesh.indicies[0]) * len(mesh.indicies), raw_data(mesh.indicies), gl.DYNAMIC_DRAW)
	
	gl.EnableVertexAttribArray(0)
	gl.VertexAttribPointer(0, 3, gl.FLOAT, false, size_of(Vertex), offset_of(Vertex, position))
	gl.EnableVertexAttribArray(1)
	gl.VertexAttribPointer(1, 4, gl.FLOAT, false, size_of(Vertex), offset_of(Vertex, color))
	gl.EnableVertexAttribArray(2)
	gl.VertexAttribPointer(2, 2, gl.FLOAT, false, size_of(Vertex), offset_of(Vertex, coords))
	gl.BindVertexArray(0)

	mesh.registered = true
	return material
}
