tool

extends Node

const MUSIC_UI_SCENE = preload("res://resources/elements/music_UI.tscn")

var event_calls = {}
var music_ui: CanvasLayer
var music_ui_track_name: Label
var music_tracks = {}
var current_music_player = null
var current_music_volume = 0.0

func add_event_listener(obj: Object, event_name: String, func_name: = ""):
	if Engine.editor_hint:
		return
	if func_name == "":
		func_name = event_name
	if event_name == "":
		return
	var func_ref = funcref(obj, func_name)
	var arr = event_calls.get(event_name, [])
	arr.append(func_ref)
	event_calls[event_name] = arr

func run_event(event_name: String):
	if Engine.editor_hint:
		return
	if event_name == "":
		return
	print("[Video] Running event: " + event_name)
	var arr = event_calls.get(event_name, [])
	for func_ref in arr:
		if func_ref.is_valid():
			func_ref.call_func()

func music_ui_text(stream):
	music_ui.visible = true
	music_ui_track_name.modulate = Color.black
	var tween: = music_ui_track_name.create_tween()
	tween.tween_property(music_ui_track_name, "modulate", Color.white, 1.0)
	var res_path: = stream.resource_path as String
	res_path = res_path.get_basename()
	res_path = res_path.get_file()
	music_ui_track_name.start(res_path + "  ")
	yield(get_tree().create_timer(5.0), "timeout")
	tween = music_ui_track_name.create_tween()
	tween.tween_property(music_ui_track_name, "modulate", Color.black, 1.0)
	yield(get_tree().create_timer(1.0), "timeout")
	music_ui.visible = false

func get_music_player(stream):
	var res_path = stream.resource_path
	var player = music_tracks.get(res_path)
	if player == null:
		player = AudioStreamPlayer.new()
		add_child(player)
		player.stream = stream
		music_tracks[res_path] = player
		player.bus = "Music"
	return player

func play_music(stream):
	if Engine.editor_hint:
		return
	music_ui_text(stream)
	var player = get_music_player(stream)
	current_music_player = player
	player.stop()
	player.play()

func init_music_ui():
	music_ui = MUSIC_UI_SCENE.instance()
	add_child(music_ui)
	music_ui_track_name = music_ui.get_node("track_name")
	music_ui.visible = false

func update_music(delta: float):
	for player in music_tracks.values():
		if player == current_music_player:
			player.volume_db = lerp(player.volume_db, current_music_volume, 0.4 * delta)
			continue
		player.volume_db = lerp(player.volume_db, -90.0, 0.2 * delta)

func _ready() -> void:
	if Engine.editor_hint:
		return
	init_music_ui()

func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return
	update_music(delta)
