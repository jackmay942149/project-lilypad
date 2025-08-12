package engine

Scene :: struct {
	entities: []Entity,
}

scene_update_entities :: proc(scene: ^Scene) {
	for &e in scene.entities {
		if e.update != nil {
			e.update(scene, &e)
		}
	}
}
