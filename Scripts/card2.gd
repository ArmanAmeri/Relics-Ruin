extends Control


@export_category("Texture")
@export var front_texture: Texture2D
@export var back_texture: Texture2D

@export_category("Angle")
@export var angle_x_max: float = 15.0
@export var angle_y_max: float = 15.0

@export_category("Oscillator")
@export var spring: float = 300.0
@export var damp: float = 10.0
@export var velocity_multiplier: float = 1.0

var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

var tween_rot: Tween
var tween_hover: Tween
var tween_destroy: Tween
var tween_handle: Tween
var tween_hover_up: Tween
var tween_hover_down: Tween

var last_mouse_pos: Vector2
var mouse_velocity: Vector2
var following_mouse: bool = false
var last_pos: Vector2
var velocity: Vector2
var is_flipped: bool = false

@onready var collision_shape = $UseCardArea/CollisionShape2D
@onready var card_info: Node2D = $CardInfo
@onready var card_viewport: SubViewportContainer = $CardInfo/SubViewportContainer
@onready var card_texture: TextureRect = $CardInfo/SubViewportContainer/SubViewport/CardTexture

var hover_up: bool = false
var defualt_hover_pos: float = 100

func _ready() -> void:
	# Convert to radians because lerp_angle is using that
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)
	collision_shape.set_deferred("disabled", true)
	
	# assign the front image into the TextureRect itself
	card_texture.texture = front_texture

	# Duplicate whatever material was assigned in the editor
	var orig = card_viewport.material
	card_viewport.material = orig.duplicate()
	card_viewport.material.set_shader_parameter("back_tex", back_texture)

func _process(delta: float) -> void:
	rotate_velocity(delta)
	follow_mouse(delta)#***********************
	
	if Input.is_action_just_pressed("ui_home"):
		flip_card()
	
	if hover_up:
		on_hover_up()
	else:
		on_hover_down()

func on_hover_up() -> void:
	position.y = position.y - 20
	if tween_hover_up and tween_hover_up.is_running():
		tween_hover_up.kill()
	tween_hover_up = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover_up.tween_property(self, "position:y", position.y - 20, 1)

func on_hover_down() -> void:
	position.y = defualt_hover_pos
	if tween_hover_down and tween_hover_down.is_running():
		tween_hover_down.kill()
	tween_hover_down = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover_down.tween_property(self, "position:y", defualt_hover_pos, 1)

func set_defualt_hover_pos(pos: float) -> void:
	defualt_hover_pos = pos
	print("Hover pos Set: ", pos)

func flip_card() -> void:
	var mat = card_viewport.material as ShaderMaterial
	var current = mat.get_shader_parameter("y_rot")
	var target = 180.0 if abs(current) < 90.0 else 0.0

	var t = create_tween()
	t.tween_property(mat, "shader_parameter/y_rot", target, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# ← this callback runs after the tween finishes
	t.tween_callback(func():is_flipped = abs(target) > 90.0)

func destroy() -> void:
	card_viewport.use_parent_material = true
	if tween_destroy and tween_destroy.is_running():
		tween_destroy.kill()
	tween_destroy = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	tween_destroy.tween_property(material, "shader_parameter/dissolve_value", 0.0, 1.2).from(1.0)
	tween_destroy.tween_callback(queue_free)

func rotate_velocity(delta: float) -> void:
	if not following_mouse: return
	#var center_pos: Vector2 = global_position - (size/2.0)
	#print("Pos: ", center_pos)
	#print("Pos: ", last_pos)
	# Compute the velocity
	velocity = (position - last_pos) / delta
	last_pos = position
	
	#print("Velocity: ", velocity)
	oscillator_velocity += velocity.normalized().x * velocity_multiplier
	
	# Oscillator stuff
	var force = -spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta
	
	card_info.rotation = displacement


func follow_mouse(_delta: float) -> void:
	if not following_mouse: return
	var mouse_pos: Vector2 = get_global_mouse_position()
	global_position = mouse_pos - (size/2.0)
	collision_shape.set_deferred("disabled", true)

func handle_mouse_click(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	
	if event.is_pressed():
		following_mouse = true
		
		# Reset tilt
		if tween_rot and tween_rot.is_running():
			tween_rot.kill()
		tween_rot = create_tween()
		tween_rot.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween_rot.tween_property(card_viewport.material, "shader_parameter/x_rot", 0.0, 0.1)
		if not is_flipped:
			tween_rot.tween_property(card_viewport.material, "shader_parameter/y_rot", 0.0, 0.1)
	else:
		# drop card
		following_mouse = false
		collision_shape.set_deferred("disabled", false)
		if tween_handle and tween_handle.is_running():
			tween_handle.kill()
		tween_handle = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween_handle.tween_property(card_info, "rotation", 0.0, 0.3)

func _gui_input(event: InputEvent) -> void:
	
	handle_mouse_click(event)
	
	# Don't compute rotation when moving the card
	if following_mouse: return
	if not event is InputEventMouseMotion: return
	
	if is_flipped: return 
	
	# Handles rotation
	# Get local mouse pos
	var mouse_pos: Vector2 = get_local_mouse_position()
	#print("Mouse: ", mouse_pos)
	#print("Card: ", position + size)
	#var diff: Vector2 = (position + size) - mouse_pos

	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	#print("Lerp val x: ", lerp_val_x)
	#print("lerp val y: ", lerp_val_y)

	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	#print("Rot x: ", rot_x)
	#print("Rot y: ", rot_y)
	
	card_viewport.material.set_shader_parameter("x_rot", rot_y)
	card_viewport.material.set_shader_parameter("y_rot", rot_x)

func _on_mouse_entered() -> void:
	hover_up = true
	z_index = 10
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(card_info, "scale", Vector2(1.1, 1.1), 1)

func _on_mouse_exited() -> void:
	hover_up = false
	z_index = 0
	# Always reset tilt
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween()
	tween_rot.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_rot.tween_property(card_viewport.material, "shader_parameter/x_rot", 0.0, 0.1)

	# Reset flip only when not flipped
	if not is_flipped:
		tween_rot.tween_property(card_viewport.material, "shader_parameter/y_rot", 0.0, 0.5)

	# Reset scale
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween()
	tween_hover.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween_hover.tween_property(card_info, "scale", Vector2.ONE, 1.0)
