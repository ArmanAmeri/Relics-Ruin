extends Label

@export var enable: bool = false

var frame_start_times: Array[int] = []  # Store milliseconds

func _process(_delta: float) -> void:
	if not enable: return
	
	var current_time = Time.get_ticks_msec()
	
	# Add current frame's start time
	frame_start_times.append(current_time)
	
	# Remove frames older than 1 second
	while frame_start_times.size() > 0 and current_time - frame_start_times[0] > 1000:
		frame_start_times.pop_at(0)
	
	text = "FPS: %d" % frame_start_times.size()
