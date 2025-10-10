package scripts

import log    "core:log"
import la     "core:math/linalg"
import carton "../../the-carton"

water_tile_update :: proc(entity: ^carton.Entity) {
	for &vertex in entity.mesh.vertices {
		dist := la.distance(vertex.position.xz + entity.position.xz, p_boat_position.xz)
		vertex.colour += 0.01
		if dist < 10 {
			vertex.colour = {0, 0, 0}
			entity.mesh.needs_update = true
		}
	}
}
