tool

extends Node

export(int) var editor_page = 0 setget set_editor_page
export(String) var on_start_event = "on_start"
export(String) var next_page_event = "next_page"

var is_started = false
var current_page = -1

func set_editor_page(value):
	editor_page = value
	for child in get_children():
		child.visible = false
	var child = get_child(editor_page)
	if is_instance_valid(child):
		child.visible = true

func next_page():
	current_page += 1
	if current_page >= get_child_count():
		return
	for child in get_children():
		child.visible = false
	var child = get_child(current_page)
	if is_instance_valid(child):
		child.visible = true
		child.call("make_current")

func _process(delta: float) -> void:
	if Engine.editor_hint:
		return
	if is_started:
		return
	if Input.is_action_just_pressed("ui_accept"):
		is_started = true
		Video.run_event(on_start_event)
		next_page()
		Video.play_music(load("res://resources/sounds/music/expt73_bend.mp3"))

func _ready() -> void:
	set_editor_page(0)
	
	if Engine.editor_hint:
		return
	
	current_page = -1	
	for child in get_children():
		child.visible = false
	
	Video.add_event_listener(self, next_page_event, "next_page")
