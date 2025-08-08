package scripts

import "../engine"

@(private = "file") key_up :: engine.Key{.W, {}, .Press}
@(private = "file") key_down :: engine.Key{.S, {}, .Press}
@(private = "file") key_left :: engine.Key{.A, {}, .Press}
@(private = "file") key_right :: engine.Key{.D, {}, .Press}

boat_update :: proc(scene: ^engine.Scene, boat: ^engine.Entity) {
	if engine.is_key_down(key_up) {
		boat.position.y += 0.001
	}
	if engine.is_key_down(key_down) {
		boat.position.y -= 0.001
	}
	if engine.is_key_down(key_left) {
		boat.position.x -= 0.001
	}
	if engine.is_key_down(key_right) {
		boat.position.x += 0.001
	}
}
