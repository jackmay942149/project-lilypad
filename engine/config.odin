package engine

// odin run . -define:RELEASE=true
RELEASE :: #config(RELEASE, false)

@(private)
MAX_ENTITIES :: 200
