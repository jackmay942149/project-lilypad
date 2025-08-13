package engine

Scene :: struct {
	entities: []Entity,
}

@(private = "file")
scene_id_list: [MAX_ENTITIES]b8

scene_update_entities :: proc(scene: ^Scene) {
	for &e in scene.entities {
		if e.update != nil {
			e.update(scene, &e)
		}
	}
}

scene_get_uid :: proc() -> (uid: int){
	for b, i in scene_id_list {
		if !b {
			scene_id_list[i] = true
			return i
		}
	}
	topic_fatal(.Engine, "No entity ids available")
	return 0
}
