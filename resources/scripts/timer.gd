extends Node

export(bool) var start_on_current = false
export(String) var start_event = ""
export(String) var stop_event = ""
export(String) var on_end_event = ""
export(float) var delay = 1.0

var timer = 0.0
var is_started = false

func on_start():
	is_started = true
	timer = 0.0

func on_stop():
	is_started = false
	timer = 0.0

func _physics_process(delta: float) -> void:
	if is_started:
		timer += delta
		if timer >= delay:
			Video.run_event(on_end_event)
			is_started = false
			timer = 0.0

func _ready() -> void:
	if start_on_current:
		get_parent().connect("on_current", self, "on_start")
	Video.add_event_listener(self, start_event, "on_start")
	Video.add_event_listener(self, stop_event, "on_stop")
