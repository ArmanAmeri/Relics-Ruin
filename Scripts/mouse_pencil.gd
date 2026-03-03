extends Control

@export var enable: bool = false

var points := PackedVector2Array()
var drawing := false

func _input(event):
	if not enable: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		drawing = event.pressed
		if drawing:
			points = [get_global_mouse_position()]
		else:
			points = []
		queue_redraw()

func _process(_delta):
	if not enable: return
	if drawing:
		var pos = get_global_mouse_position()
		if points.is_empty() or points.size() == 0 or pos.distance_to(points[points.size() - 1]) > 2:
			points.append(pos)
			queue_redraw()

func _draw():
	if points.size() > 1:
		draw_polyline(points, Color(0, 0.7, 1), 4.0, true)
