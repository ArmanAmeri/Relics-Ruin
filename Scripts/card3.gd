extends RigidBody2D

const SIZE: Vector2 = Vector2(128, 192)

@onready var label: RichTextLabel = $Text
@onready var card_image: Sprite2D = $cardImage
@onready var area: Area2D = $Area2D

@export var hand_parent: Node
@export var usingcard_parent: Node
@export var text: String

var is_held: bool = false
var is_mouse_over: bool = false # Track if mouse is over the card
var is_moving: bool = false
var speed

func _ready() -> void:
	label.text = text
	area.mouse_entered.connect(_on_hover_enter)
	area.mouse_exited.connect(_on_hover_exit)

func _physics_process(_delta):
	if is_held:
		global_position = global_position.lerp(get_global_mouse_position(), 0.5)
	
	speed = get_linear_velocity().length()
	is_moving = speed > 1.5

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and is_mouse_over: # Check if mouse is over the card
			_pickup()
			_on_hover_exit()
		elif not event.pressed and is_held:
			_release()

func _pickup():
	is_held = true
	# Disable physics and let us move it manually
	freeze = true
	sleeping = false
	self.reparent(usingcard_parent)

func _release():
	is_held = false
	freeze = false
	
	await get_tree().process_frame  # Let physics reactivate
	var impulse = (get_global_mouse_position() - global_position) * 5.0
	apply_impulse(impulse)
	if area.overlaps_area(hand_parent):
		hand_parent.draw(self)


func _on_hover_enter():
	is_mouse_over = true # Set flag when mouse enters
	if not is_moving and not is_held:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)

func _on_hover_exit():
	is_mouse_over = false # Clear flag when mouse exits
	if not is_moving:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
