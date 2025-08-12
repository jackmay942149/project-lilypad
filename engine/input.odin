package engine

import "base:runtime"
import "core:log"
import "core:math/bits"
import "vendor:glfw"

@(private)
input_ctx: Input_Context

// Note(Jack): The current input system uses a map to assign key binds,
// this is used to reduce code complexity and gives the side effect of
// binding a key overriding the old bind. An array would likely be more
// performant here but I prefer this at time of writing

input_init :: proc(window: glfw.WindowHandle) {
	assert(window != nil)
	assert(!input_ctx.initialised)
	input_ctx.odin_ctx = context
	input_ctx.global_map.binds = make(map[Input_Key]proc())
	input_ctx.global_map.toggles = make(map[Input_Key]Input_Toggle)
	input_ctx.window = window
	glfw.SetKeyCallback(window, key_callback)
	init_gamepads()
	// core.add_update_callback(update_gamepads)
	// core.add_update_callback(update_mouse)
	input_ctx.initialised = true
}

@(require_results)
init_mapping_ctx :: proc(window: glfw.WindowHandle) -> Mapping_Context {
	assert(window != nil)
	assert(input_ctx.initialised)
	ctx := Mapping_Context {
		binds   = make(map[Input_Key]proc()),
		toggles = make(map[Input_Key]Input_Toggle),
	}
	return ctx
}

bind_key :: proc {
	bind_key_global,
	bind_key_ctx,
}

bind_toggle :: proc {
	bind_toggle_global,
	bind_toggle_ctx,
}

bind_mapping_ctx :: proc(ctx: ^Mapping_Context) {
	input_ctx.current_map = ctx
}

is_key_down :: proc(key: Input_Key) -> bool {
	return input_ctx.key_states[key.code].isDown
}

get_axis :: proc(axis: Input_Axis) -> f32 {
	for g, i in input_ctx.gamepad_states {
		if g.initialised {
			return g.state.axes[axis]
		}
	}
	return 0
}

get_axis_delta :: proc(axis: Input_Axis) -> f32 {
	for g, i in input_ctx.gamepad_states {
		if g.initialised {
			return g.state.axes[axis] - g.prev_state.axes[axis]
		}
	}
	return 0
}

get_mouse_pos :: proc() -> (f64, f64) {
	using input_ctx.mouse_state.curr
	return pos.x, pos.y
}

get_mouse_delta :: proc() -> (f64, f64) {
	using input_ctx.mouse_state
	return curr.pos.x - prev.pos.x, curr.pos.y - prev.pos.y
}

disable_cursor :: proc() {
	glfw.SetInputMode(input_ctx.window, glfw.CURSOR, glfw.CURSOR_DISABLED)
}

show_cursor :: proc() {
	glfw.SetInputMode(input_ctx.window, glfw.CURSOR, glfw.CURSOR_NORMAL)
}

hide_cursor :: proc() {
	glfw.SetInputMode(input_ctx.window, glfw.CURSOR, glfw.CURSOR_HIDDEN)
}

capture_cursor :: proc() {
	glfw.SetInputMode(input_ctx.window, glfw.CURSOR, glfw.CURSOR_CAPTURED)
}

inject_key :: proc(key: Input_Key) {
	input_callback(i32(key.code), i32(key.action), transmute(i32)key.modifier)
}

destroy :: proc(contexts: ..^Mapping_Context) {
	assert(input_ctx.initialised)
	for ctx in contexts {
		delete(ctx.binds)
		delete(ctx.toggles)
	}
	delete(input_ctx.global_map.toggles)
	delete(input_ctx.global_map.binds)
	input_ctx.initialised = false
}

@(private)
init_gamepads :: proc() {
	for &g, i in input_ctx.gamepad_states {
		if glfw.JoystickPresent(i32(i)) {
			if glfw.JoystickIsGamepad(i32(i)) {
				g.is_gamepad = true
				g.initialised = true
			}
		}
	}
}

@(private)
update_gamepads :: proc() {
	for &g, i in input_ctx.gamepad_states {
		if !g.is_gamepad {
			continue
		}
		g.prev_state = g.state
		glfw.GetGamepadState(i32(i), &g.state)
		for value, i in g.state.buttons {
			if g.prev_state.buttons[i] == value do continue
			input_callback(i32(i), i32(value), 0)
		}
	}
}

@(private)
update_mouse :: proc() {
	input_ctx.mouse_state.prev.pos = input_ctx.mouse_state.curr.pos
	input_ctx.mouse_state.curr.pos.x, input_ctx.mouse_state.curr.pos.y = glfw.GetCursorPos(
		input_ctx.window,
	)
}

@(private)
key_callback :: proc "c" (
	window: glfw.WindowHandle,
	key_code: i32,
	scan_code: i32,
	action: i32,
	mods: i32,
) {
	context = input_ctx.odin_ctx
	input_callback(key_code, action, mods)
}

@(private)
input_callback :: proc(key_code, action, mods: i32) { 	// TODO: Change this to accept a key
	if action != glfw.REPEAT do input_ctx.key_states[key_code].isDown = !input_ctx.key_states[key_code].isDown
	key := Input_Key {
		code     = transmute(Input_Key_Code)key_code,
		modifier = transmute(Input_Key_Modifiers)mods,
		action   = transmute(Input_Key_Action)action,
	}
	// core.topic_info(.Input, key.code, key.action)
	if input_ctx.current_map != nil && key in input_ctx.current_map.binds {
		input_ctx.current_map.binds[key]()
		if key in input_ctx.current_map.toggles {
			if (input_ctx.current_map.binds[key] == input_ctx.current_map.toggles[key].first) {
				bind_key(input_ctx.current_map, key, input_ctx.current_map.toggles[key].second)
				return
			} else {
				bind_key(input_ctx.current_map, key, input_ctx.current_map.toggles[key].first)
				return
			}
		}
	}
	if key in input_ctx.global_map.binds {
		input_ctx.global_map.binds[key]()
		if key in input_ctx.global_map.toggles {
			if (input_ctx.global_map.binds[key] == input_ctx.global_map.toggles[key].first) {
				bind_key(key, input_ctx.global_map.toggles[key].second)
			} else {
				bind_key(key, input_ctx.global_map.toggles[key].first)
			}
		}
	}
}

@(private)
bind_key_global :: proc(key: Input_Key, func: proc()) {
	input_ctx.global_map.binds[key] = func
}

@(private)
bind_toggle_global :: proc(key: Input_Key, first: proc(), second: proc()) {
	toggle := Input_Toggle{first, second}
	input_ctx.global_map.toggles[key] = toggle
	bind_key(key, first)
}

@(private)
bind_key_ctx :: proc(ctx: ^Mapping_Context, key: Input_Key, func: proc()) {
	ctx.binds[key] = func
}

@(private)
bind_toggle_ctx :: proc(ctx: ^Mapping_Context, key: Input_Key, first: proc(), second: proc()) {
	toggle := Input_Toggle{first, second}
	ctx.toggles[key] = toggle
	bind_key_ctx(ctx, key, first)
}

