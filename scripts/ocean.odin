package scripts

import "../engine"
import la "core:math/linalg"

@(private = "file") moss_regrow_rate :: 0.005
@(private = "file") moss_removal_distance :: 0.05

ocean_update :: proc(scene: ^engine.Scene, ocean: ^engine.Entity) {
	for e in scene.entities {
		if e.tag == .Boat {
			ocean.boat_pos = e.position
		}
	}
	for &v in ocean.mesh.vertices {
		amount := v.color.r
		amount += moss_regrow_rate
		amount = min(amount, 1.0)
		if la.distance(v.position.xy, ocean.boat_pos) < moss_removal_distance {
			amount = 0
		}
		v.color = {amount, amount, amount, 1.0}
	}
}
