package engine

import "vendor:glfw"

KeyCode :: enum i32 {
	W = glfw.KEY_W,
	A = glfw.KEY_A,
	S = glfw.KEY_S,
	D = glfw.KEY_D,
}

is_key_down :: proc(window: Window, key: KeyCode) -> bool {
	state := glfw.GetKey(window.handle, i32(key))
	if state == glfw.PRESS {
		return true
	}
	return false
}
