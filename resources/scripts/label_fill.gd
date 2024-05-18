tool

extends Label

export(float) var letter_delay = 0.02
export(bool) var start_on_current = true
export(bool) var start_on_event = false
export(String) var start_event = ""
export(int) var font_size = 24 setget set_font_size
export(int) var outline_size = 6 setget set_outline_size

var is_started = false
var timer = 0.0
var target_text = ""
var letter_id = 0

func set_outline_size(value):
	outline_size = value
	var font: = get_font("font") as DynamicFont
	font = font.duplicate()
	font.outline_color = Color.black
	font.outline_size = outline_size
	add_font_override("font", font)

func set_font_size(value):
	font_size = value
	var font: = get_font("font") as DynamicFont
	font = font.duplicate()
	font.size = font_size
	add_font_override("font", font)

func start(target_text):
	self.target_text = target_text
	text = ""
	on_start()

func on_start():
	set_font_size(font_size)
	timer = 0.0
	is_started = true
	letter_id = 0

func _physics_process(delta: float) -> void:
	if is_started:
		timer += delta
		if timer > letter_delay:
			timer = 0.0
			if letter_id < len(target_text):
				text += target_text[letter_id]
				letter_id += 1
			else:
				is_started = false

func _ready() -> void:
	if Engine.editor_hint:
		return
	target_text = text
	text = ""
	if start_on_event:
		Video.add_event_listener(self, start_event, "on_start")
	if start_on_current:
		get_parent().connect("on_current", self, "on_start")
	for frame in range(3):
		yield(VisualServer, "frame_post_draw")
	set_font_size(font_size)
