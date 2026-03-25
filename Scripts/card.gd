extends Control
class_name Card

signal DescTextChanged()

const SIZE: Vector2 = Vector2(192, 240)
const SCALE: Vector2 = Vector2(1, 1)

@export var cardID: String

@onready var use_card_area: Area2D = $UseCardArea
@onready var collision_shape: CollisionShape2D = $UseCardArea/CollisionShape2D
@onready var label: RichTextLabel = $SubViewportContainer/SubViewport/CardTexture/label
@onready var card_texture: TextureRect = $SubViewportContainer/SubViewport/CardTexture
@onready var card_title: Label = $SubViewportContainer/SubViewport/CardTexture/Title
@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var card_background: ColorRect = $SubViewportContainer/SubViewport/CardBackground


var tween_hover: Tween
var tween_discard: Tween
var CardMoveTween: Tween

var focusTimer: Timer
var following_mouse: bool = false
var swipeDir: String = ""
var useCardDest: Vector2 = Vector2(288, 100)
var curveRatio: int = 4 
var curMouseSpeed: float = 0

func _ready() -> void:
	ChamberInfo.setTotalCards("add", 1)
	
	_setRarityColor()
	
	# Card Initilazation Prepreations
	if IL.get_item_info(cardID, "cardtype") == IL.cardType.WAGER:
		var options = IL.get_item_info(cardID, "wager_options")
		for item in options:
			if item > 1:
				label.text += "\n OR \n"
			label.text += "[" + str(options[item]["chance"]) + "%] " + options[item]["desc"]
	elif IL.get_item_info(cardID, "cardtype") == IL.cardType.CURSE:
		var options = IL.get_item_info(cardID, "curse_options")
		for item in options:
			if item > 1:
				label.text += "\n AND \n"
			label.text += options[item]["desc"]
	elif IL.get_item_info(cardID, "cardtype") == IL.cardType.FATE:
		var options = IL.get_item_info(cardID, "fate_options")
		for item in options:
			if item > 1:
				label.text += "\n OR \n"
			label.text += options[item]["desc"]
	else:
		label.text = IL.get_item_info(cardID, "card_desc")
	card_texture.texture = IL.get_item_info(cardID, "texture")
	card_title.text = IL.get_item_info(cardID, "title")
	DescTextChanged.emit()
	
	collision_shape.disabled = true
	SignalBus.swiped.connect(on_swipe_change)

func _setRarityColor() -> void:
	var rarity_value = IL.get_item_info(cardID, "rarity")
	var rarity_id = IL.get_rarity_id(rarity_value)

	var color = IL.get_item_info(rarity_id, "color")
	card_background.color = Color(color)

func _process(delta: float) -> void:
	#rotate_velocity(delta)
	follow_mouse(delta)
	#print(get_parent())
	#if text == "num 10":
	#	print("name: ", text, "  pos: ", position.y, "  rot: ", rotation_degrees)
	#elif text == "num 9":
	#	print("name: ", text, "  pos: ", position.y, "  rot: ", rotation_degrees)
	#elif text == "num 8":
	#	print("name: ", text, "  pos: ", position.y, "  rot: ", rotation_degrees)

func _gui_input(event: InputEvent):
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	
	if event.pressed:
		_pickup()
	else:
		_release()

func _pickup():
	if self.get_parent() is Deck:
		return
	
	collision_shape.disabled = false
	following_mouse = true
	rotation_degrees = 0
	SignalBus.pickedUp.emit(self, true)
	
	SignalBus.overlayToggle.emit()

func _release():
	# drop card
	following_mouse = false
	collision_shape.set_deferred("disabled", false)

	## NORTH
	#if swipeDir == "North":
		##print("Used Card Use Animation")
		#curMouseSpeed = SwipeManager.mouse_speed
#
		#if CardMoveTween and CardMoveTween.is_running():
				#CardMoveTween.kill()
		#CardMoveTween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
		#CardMoveTween.tween_property(self, "global_position", ChamberInfo.useCardDest - (size * 1.2 / 2.0) , 0.5)
		##useCardAnim()
#
	## EAST
	#elif swipeDir == "East" or swipeDir == "NE" or swipeDir == "SE":
		##print("Used Card East Animation")
		#curMouseSpeed = SwipeManager.mouse_speed
#
		#if CardMoveTween and CardMoveTween.is_running():
				#CardMoveTween.kill()
		#CardMoveTween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
		#CardMoveTween.tween_property(self, "global_position", ChamberInfo.burnCardDest - (size * 1.2 / 2.0), 0.5)
		##useCardAnim()
#
	## WEST
	#elif swipeDir == "West" or swipeDir == "NW" or swipeDir == "SW":
		##print("Used Card West Animation")
		#curMouseSpeed = SwipeManager.mouse_speed
#
		#if CardMoveTween and CardMoveTween.is_running():
				#CardMoveTween.kill()
		#CardMoveTween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
		#CardMoveTween.tween_property(self, "global_position", ChamberInfo.inspectCardDest - (size * 1.2 / 2.0), 0.4)
		##useCardAnim()
		#
		#await CardMoveTween.finished
		#SignalBus.pickedUp.emit(self, false)#### BUUUUGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
#
	#else:
		#SignalBus.overlayToggle.emit()
		#SignalBus.pickedUp.emit(self, false)#### BUUUUGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
		##print("picked up release signal")
	##print("Released")

func follow_mouse(_delta: float) -> void:
	if not following_mouse: return
	var mouse_pos: Vector2 = get_global_mouse_position()
	global_position = global_position.lerp(mouse_pos - (size/2.0), 0.5)#mouse_pos - (size/2.0)
	collision_shape.set_deferred("disabled", true)
	if Input.is_action_just_released("press"):
		_release()

func _on_mouse_entered() -> void:
	if self.get_parent() is Deck: return
	z_index = 10
	
	# Set Scale
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween_hover.tween_property(self, "scale", Vector2((scale.x + 0.2), scale.y + 0.2), 1)

func _on_mouse_exited() -> void: 
	z_index = 0
	
	# Reset scale
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween_hover.tween_property(self, "scale", SCALE, 1)

func destroy() -> void:
	if tween_discard and tween_discard.is_running():
		tween_discard.kill()
	tween_discard = create_tween()
	tween_discard.tween_property(sub_viewport_container.material, "shader_parameter/dissolve_value", 0, 1).from(1)
	await tween_discard.finished
	ChamberInfo.setTotalCards("subtract", 1)
	queue_free()

func on_swipe_change(dir) -> void:
	swipeDir = dir
	#print("swipeChange: ", dir)

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r
