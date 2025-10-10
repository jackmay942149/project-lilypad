package scripts

import carton "../../the-carton"

@(private)
p_boat_position: [3]f32

boat_update :: proc(entity: ^carton.Entity) {
	if carton.is_key_down(carton.Key.W) {
		entity.position.x += 0.01
	}
	if carton.is_key_down(carton.Key.S) {
		entity.position.x -= 0.01
	}
	if carton.is_key_down(carton.Key.D) {
		entity.position.z += 0.01
	}
	if carton.is_key_down(carton.Key.A) {
		entity.position.z -= 0.01
	}
	 p_boat_position = entity.position
}
