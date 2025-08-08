package scripts

import "../engine"
import la "core:math/linalg"

ocean_update :: proc(scene: ^engine.Scene, ocean: ^engine.Entity) {
	for e in scene.entities {
		if e.tag == .Boat {
			ocean.boat_pos = e.position
		}
	}
	for &v in ocean.mesh.vertices {
		amount := v.color.r
		amount += ocean.moss_regrow_rate
		amount = min(amount, 1.0)
		if la.distance(v.position.xy, ocean.boat_pos) < ocean.moss_removal_distance {
			amount = 0
		}
		v.color = {amount, amount, amount, 1.0}
	}
}
