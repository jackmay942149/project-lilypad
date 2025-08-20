package scripts

import "../engine"

@(private = "file")
move_speed:f32 = 0.1 

lilypad_collision_during :: proc(this: ^engine.Entity, other: ^engine.Entity) {
	engine.topic_info(.Temp, "Collison")
	this.position += move_speed * (this.position - other.position)
}
