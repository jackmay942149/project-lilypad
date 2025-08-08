package scripts

import "../engine"

boat_update :: proc(scene: ^engine.Scene, boat: ^engine.Entity) {
	if engine.is_key_down(boat.window, .W) {
		boat.position.y += 0.001
	}
	if engine.is_key_down(boat.window, .S) {
		boat.position.y -= 0.001
	}
	if engine.is_key_down(boat.window, .A) {
		boat.position.x -= 0.001
	}
	if engine.is_key_down(boat.window, .D) {
		boat.position.x += 0.001
	}
}
