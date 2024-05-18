tool

extends Control

export(bool) var editor_make_current = false setget set_editor_make_current
export(String) var make_current_event = ""
export(String) var on_current_event = ""

signal on_current()

func set_editor_make_current(value):
	if value == false:
		return
	for child in get_parent().get_children():
		child.visible = false
	visible = true

func make_current():
	for child in get_parent().get_children():
		child.visible = false
	visible = true
	Video.run_event(on_current_event)
	emit_signal("on_current")
	get_parent().set("current_page", get_index())

func _ready() -> void:
	Video.add_event_listener(self, make_current_event, "make_current")
