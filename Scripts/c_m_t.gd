extends RigidBody2D
class_name CMT

var dragging := false
var mouse_pos: Vector2
var prev_mouse_pos: Vector2
var mouse_velocity: Vector2

@export var max_velocity: int = 900
@export var drag: float = 0.98  # 0 = full stop, 1 = no drag

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			sleeping = false
			prev_mouse_pos = get_global_mouse_position()
		else:
			dragging = false
			linear_velocity = mouse_velocity.limit_length(max_velocity) # apply throw

func _physics_process(delta):
	mouse_pos = get_global_mouse_position()
	
	# calculate mouse velocity
	mouse_velocity = (mouse_pos - prev_mouse_pos) / delta
	prev_mouse_pos = mouse_pos

func _integrate_forces(state):
	if dragging:
		state.transform.origin = mouse_pos
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
	else:
		# exponential drag when not dragging
		state.linear_velocity *= drag
		state.angular_velocity *= drag
