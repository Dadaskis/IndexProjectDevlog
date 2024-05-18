extends Node

export(bool) var start_on_current = true
export(bool) var start_on_event = false
export(String) var start_event = ""
export(float, 0.0, 1.0) var volume = 1.0

func on_start():
	Video.current_music_volume = clamp(linear2db(volume), -90.0, 0.0)

func _ready() -> void:
	if Engine.editor_hint:
		return
	if start_on_event:
		Video.add_event_listener(self, start_event, "on_start")
	if start_on_current:
		get_parent().connect("on_current", self, "on_start")
