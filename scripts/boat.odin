package scripts

import "../engine"

@(private = "file") key_up :: engine.Input_Key{.W, {}, .Press}
@(private = "file") key_down :: engine.Input_Key{.S, {}, .Press}
@(private = "file") key_left :: engine.Input_Key{.A, {}, .Press}
@(private = "file") key_right :: engine.Input_Key{.D, {}, .Press}

@(private = "file") speed :: 0.01

@(private) boat_position : [2]f32

boat_update :: proc(scene: ^engine.Scene, boat: ^engine.Entity) {
	boat_position = boat.position
	
	if engine.is_key_down(key_up) {
		boat.position.y += speed
	}
	if engine.is_key_down(key_down) {
		boat.position.y -= speed
	}
	if engine.is_key_down(key_left) {
		boat.position.x -= speed
	}
	if engine.is_key_down(key_right) {
		boat.position.x += speed
	}
}
