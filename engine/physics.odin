package engine

import la "core:math/linalg"

physics_update :: proc(scene: ^Scene) {
	for &e in scene.entities {
		if e.collision_radius == 0 {
			continue
		}

		for &other in scene.entities {
			if e == other {
				continue
			}
			if la.distance(e.position, other.position) < f32(e.collision_radius + other.collision_radius) {
				if (e.collision_during != nil) {
					e.collision_during(&e, &other)
				}
			}
		}
	}
}
