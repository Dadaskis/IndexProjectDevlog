tool

extends AudioStreamPlayer

export(Array, Resource) var time_events = [] setget set_time_events
export(String) var start_event = ""
export(String) var on_finish_event = ""
#export(float, 0.0, 1.0) var volume = 1.0

func set_time_events(value):
	time_events = value
	for index in range(len(time_events)):
		var event = time_events[index]
		if event == null:
			time_events[index] = AudioTimeEvent.new()

func start():
	play()

func on_finish():
	Video.run_event(on_finish_event)

func _ready() -> void:
	Video.add_event_listener(self, start_event, "start")
	connect("finished", self, "on_finish")

func _physics_process(delta: float) -> void:
	if not playing:
		return
	
	for res in time_events:
		var time_event: = res as AudioTimeEvent
		if time_event.is_called:
			continue
		var target_seconds = time_event.seconds
		var event = time_event.event
		var cur_seconds = get_playback_position()
		
		var dist = abs(cur_seconds - target_seconds)
		if dist < (delta * 2.0):
			time_event.is_called = true
			Video.run_event(event)
