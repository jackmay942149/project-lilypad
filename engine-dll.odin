package main

foreign import pl "engine.lib"

@(default_calling_convention = "odin")
foreign pl {
	window_init         :: proc(width, height: int, title: string) ---
	window_should_close :: proc() -> bool ---
	window_update       :: proc() ---
	window_destroy      :: proc() ---
}
