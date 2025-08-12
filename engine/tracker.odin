package engine

import "core:mem"

@(require_results)
tracker_init :: proc() -> (^mem.Tracking_Allocator, mem.Allocator) {
	tracker := new(mem.Tracking_Allocator)
	mem.tracking_allocator_init(tracker, context.allocator)
	topic_info(.Engine, "Created tracking allocator")
	return tracker, mem.tracking_allocator(tracker)
}

@(disabled = RELEASE)
tracker_check :: proc(tracker: ^mem.Tracking_Allocator) {
	topic_info(.Engine, "Checking tracker allocator")
	for _, elem in tracker.allocation_map {
		topic_warn(.Engine, "Allocation not freed:", elem.size, "bytes @", elem.location)
	}
	for elem in tracker.bad_free_array {
		topic_warn(.Engine, "Incorrect frees:", elem.memory, "@", elem.location)
	}
}

@(disabled = RELEASE)
tracker_assert_empty :: proc(tracker: ^mem.Tracking_Allocator) {
	tracker_check(tracker)
	assert(len(tracker.allocation_map) == 0)
	assert(len(tracker.bad_free_array) == 0)
}

tracker_destroy :: proc(tracker: ^mem.Tracking_Allocator) {
	mem.tracking_allocator_destroy(tracker)
}

