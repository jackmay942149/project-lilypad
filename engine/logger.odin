package engine

import "base:runtime"
import "core:log"
import "core:os"
import "core:fmt"

Logger_User :: enum {
	All,
	Jack,
}

Logger_Topic :: enum {
	All,
	Temp,
	Engine,
}

@(private = "file")
Logger_Context :: struct {
	user:         Logger_User,
	topic:        Logger_Topic,
	log: ^log.Logger,
}

@(private = "file")
logger_ctx: Logger_Context

@(require_results)
init_logger :: proc(
	user := Logger_User.All,
	topic := Logger_Topic.All,
	file: string = "",
	allocator := context.allocator,
) -> log.Logger {
	context.allocator = allocator
	logger_ctx = {user, topic, nil}

	// Create terminal logger
	info_opt := log.Options{.Level, .Terminal_Color}
	info_log := log.create_console_logger(.Info, info_opt, "", context.allocator)
	context.logger = info_log
	logger_ctx.log = &info_log

	// Return early if no file logger
	if file == "" {
		logger := info_log
		topic_info(.Engine, "Created logger")
		return logger
	}

	// Create file logger
	os.remove(file)
	handle, err := os.open(file, os.O_CREATE | os.O_WRONLY)
	if err != nil {
		log.fatal("Failed to open file logger")
	}
	debug_log := log.create_file_logger(
		handle,
		.Debug,
		log.Default_File_Logger_Opts,
		"",
		context.allocator,
	)

	logger := log.create_multi_logger(debug_log, info_log, allocator = context.allocator)
	logger_ctx.log = &logger
	topic_info(.Engine, "Created logger")
	return logger
}

@(disabled = RELEASE)
topic_info :: proc(topic: Logger_Topic, args: ..any, location := #caller_location) {
	if logger_ctx.topic != .All && topic != logger_ctx.topic && topic != .All {
		return
	}
	to_log:= make([]any, len(..args) + 2)
	defer delete(to_log)
	to_log[0] = topic
	to_log[1] = location
	for a, i in 0..<len(..args) {
		to_log[2+i] = args[i]
	}
	log.info(..to_log)
}

@(disabled = RELEASE)
topic_warn :: proc(topic: Logger_Topic, args: ..any, location := #caller_location) {
	if logger_ctx.topic != .All && topic != logger_ctx.topic && topic != .All {
		return
	}
	to_log:= make([]any, len(..args) + 2)
	defer delete(to_log)
	to_log[0] = topic
	to_log[1] = location
	for a, i in 0..<len(..args) {
		to_log[2+i] = args[i]
	}
	log.warn(..to_log)
}

