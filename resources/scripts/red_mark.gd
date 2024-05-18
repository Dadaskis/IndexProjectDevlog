extends Control

export(bool) var start_on_current = true
export(float) var time = 0.25
export(float) var delay = 0.25
export(bool) var start_on_event = false
export(String) var start_event = ""

var x_size = 0.0
var is_started = false
var timer = 0.0

func start():
	is_started = true
	timer = -delay

func _physics_process(delta: float) -> void:
	if not is_started:
		return
	timer += delta
	if timer < 0.0:
		return
	var progress = pow((timer / time), 2.0)
	progress = clamp(progress, 0.0, 1.0)
	rect_size.x = lerp(0.0, x_size, progress)

func _ready() -> void:
	if start_on_current:
		get_parent().connect("on_current", self, "start")
	
	if start_on_event:
		Video.add_event_listener(self, start_event, "start")
	
	yield(VisualServer, "frame_post_draw")
	yield(VisualServer, "frame_post_draw")
	
	x_size = rect_size.x
	rect_size.x = 0.0
