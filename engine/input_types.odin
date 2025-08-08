package engine

import "base:runtime"
import "vendor:glfw"

Key :: struct {
	code:     Key_Code,
	modifier: Key_Modifiers,
	action:   Key_Action,
}

Axis :: enum {
	Left_X    = glfw.GAMEPAD_AXIS_LEFT_X,
	Left_Y    = glfw.GAMEPAD_AXIS_LEFT_Y,
	Right_X   = glfw.GAMEPAD_AXIS_RIGHT_X,
	Right_Y   = glfw.GAMEPAD_AXIS_RIGHT_Y,
	Trigger_L = glfw.GAMEPAD_AXIS_LEFT_TRIGGER,
	Trigger_R = glfw.GAMEPAD_AXIS_RIGHT_TRIGGER,
}

Mapping_Context :: struct {
	toggles: map[Key]Toggle,
	binds:   map[Key]proc(),
}

@(private)
Key_Code :: enum i32 {
	A             = glfw.KEY_A,
	B             = glfw.KEY_B,
	C             = glfw.KEY_C,
	D             = glfw.KEY_D,
	E             = glfw.KEY_E,
	F             = glfw.KEY_F,
	G             = glfw.KEY_G,
	H             = glfw.KEY_H,
	I             = glfw.KEY_I,
	J             = glfw.KEY_J,
	K             = glfw.KEY_K,
	L             = glfw.KEY_L,
	M             = glfw.KEY_M,
	N             = glfw.KEY_N,
	O             = glfw.KEY_O,
	P             = glfw.KEY_P,
	Q             = glfw.KEY_Q,
	R             = glfw.KEY_R,
	S             = glfw.KEY_S,
	T             = glfw.KEY_T,
	U             = glfw.KEY_U,
	V             = glfw.KEY_V,
	W             = glfw.KEY_W,
	X             = glfw.KEY_X,
	Y             = glfw.KEY_Y,
	Z             = glfw.KEY_Z,
	_0            = glfw.KEY_0,
	_1            = glfw.KEY_1,
	_2            = glfw.KEY_2,
	_3            = glfw.KEY_3,
	_4            = glfw.KEY_4,
	_5            = glfw.KEY_5,
	_6            = glfw.KEY_6,
	_7            = glfw.KEY_7,
	_8            = glfw.KEY_8,
	_9            = glfw.KEY_9,
	Space         = glfw.KEY_SPACE,
	Apostrophe    = glfw.KEY_APOSTROPHE,
	Comma         = glfw.KEY_COMMA,
	Minus         = glfw.KEY_MINUS,
	Period        = glfw.KEY_PERIOD,
	Slash         = glfw.KEY_SLASH,
	Semicolon     = glfw.KEY_SEMICOLON,
	Equal         = glfw.KEY_EQUAL,
	Left_bracket  = glfw.KEY_LEFT_BRACKET,
	Backslash     = glfw.KEY_BACKSLASH,
	Right_bracket = glfw.KEY_RIGHT_BRACKET,
	Grave_accent  = glfw.KEY_GRAVE_ACCENT,
	Escape        = glfw.KEY_ESCAPE,
	Enter         = glfw.KEY_ENTER,
	Tab           = glfw.KEY_TAB,
	Backspace     = glfw.KEY_BACKSPACE,
	Insert        = glfw.KEY_INSERT,
	Delete        = glfw.KEY_DELETE,
	Right         = glfw.KEY_RIGHT,
	Left          = glfw.KEY_LEFT,
	Down          = glfw.KEY_DOWN,
	Up            = glfw.KEY_UP,
	Page_up       = glfw.KEY_PAGE_UP,
	Page_down     = glfw.KEY_PAGE_DOWN,
	Home          = glfw.KEY_HOME,
	End           = glfw.KEY_END,
	Caps_lock     = glfw.KEY_CAPS_LOCK,
	Scroll_lock   = glfw.KEY_SCROLL_LOCK,
	Num_lock      = glfw.KEY_NUM_LOCK,
	Print_screen  = glfw.KEY_PRINT_SCREEN,
	Pause         = glfw.KEY_PAUSE,
	F1            = glfw.KEY_F1,
	F2            = glfw.KEY_F2,
	F3            = glfw.KEY_F3,
	F4            = glfw.KEY_F4,
	F5            = glfw.KEY_F5,
	F6            = glfw.KEY_F6,
	F7            = glfw.KEY_F7,
	F8            = glfw.KEY_F8,
	F9            = glfw.KEY_F9,
	F10           = glfw.KEY_F10,
	F11           = glfw.KEY_F11,
	F12           = glfw.KEY_F12,
	Gamepad_A     = glfw.GAMEPAD_BUTTON_A,
	Gamepad_B     = glfw.GAMEPAD_BUTTON_B,
	Gamepad_X     = glfw.GAMEPAD_BUTTON_X,
	Gamepad_Y     = glfw.GAMEPAD_BUTTON_Y,
	Gamepad_LB    = glfw.GAMEPAD_BUTTON_LEFT_BUMPER,
	Gamepad_RB    = glfw.GAMEPAD_BUTTON_RIGHT_BUMPER,
	Gamepad_Back  = glfw.GAMEPAD_BUTTON_BACK,
	Gamepad_Start = glfw.GAMEPAD_BUTTON_START,
	Gamepad_Guide = glfw.GAMEPAD_BUTTON_GUIDE,
	Gamepad_L3    = glfw.GAMEPAD_BUTTON_LEFT_THUMB,
	Gamepad_R3    = glfw.GAMEPAD_BUTTON_RIGHT_THUMB,
	Gamepad_Up    = glfw.GAMEPAD_BUTTON_DPAD_UP,
	Gamepad_Right = glfw.GAMEPAD_BUTTON_DPAD_RIGHT,
	Gamepad_Down  = glfw.GAMEPAD_BUTTON_DPAD_DOWN,
	Gamepad_Left  = glfw.GAMEPAD_BUTTON_DPAD_LEFT,
}

@(private)
Modifier :: enum i32 {
	Shift,
	Ctrl,
	Alt,
}
@(private)
Key_Modifiers :: bit_set[Modifier;i32]

@(private)
Key_Action :: enum i32 {
	Release = glfw.RELEASE,
	Press   = glfw.PRESS,
	Repeat  = glfw.REPEAT,
}

@(private)
Toggle :: struct {
	first:  proc(),
	second: proc(),
}

@(private)
Input_Context :: struct {
	odin_ctx:       runtime.Context,
	window:         glfw.WindowHandle,
	global_map:     Mapping_Context,
	current_map:    ^Mapping_Context,
	gamepad_states: [glfw.JOYSTICK_LAST]Gamepad_Info,
	key_states:     [glfw.KEY_LAST + 1]Key_Info,
	mouse_state:    Mouse_Info,
	initialised:    bool,
}

@(private)
Mouse_Info :: struct {
	prev: Mouse_State,
	curr: Mouse_State,
}

@(private)
Mouse_State :: struct {
	pos: [2]f64,
}

@(private)
Key_Info :: struct {
	code:   Key_Code,
	isDown: bool,
}

@(private)
Gamepad_Info :: struct {
	prev_state:  glfw.GamepadState,
	state:       glfw.GamepadState,
	is_gamepad:  bool,
	initialised: bool,
}

