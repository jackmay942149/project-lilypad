package main

foreign import pl {
	"./engine.lib",
}

@(default_calling_convention="odin")
foreign pl {
	give_one :: proc() -> int ---
}

import "core:fmt"

main :: proc() {
	fmt.println(give_one())
}
