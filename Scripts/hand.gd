extends Control
class_name Hand

const CARD = preload("res://Scenes/card.tscn")

@onready var holding_card: Control = $"../HoldingCard"

var curCards: int = 0

@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees: int = 3
@export var x_sep: int = -10
@export var y_min: int = 0
@export var y_max: int = -6

func _ready() -> void:
	SignalBus.pickedUp.connect(_on_pickup)

func draw(card: Card) -> void:
	if curCards < ChamberInfo.handCapacity:
		if card.get_parent():
			# Reparent the node to the new parent
			card.reparent(self)
			curCards += 1
		else:
			# If the node has no parent, simply add it to the new parent
			self.add_child(card)
			curCards += 1
		_update_cards()
	else:
		print("Hand Full")

func discard() -> void:
	if get_child_count() < 1: return
	
	var child: Card = get_child(-1)
	child.reparent(get_tree().root)
	child.destroy()
	curCards -= 1
	
	_update_cards()

func _on_pickup(card: Card, PickedUp: bool) -> void:
	if PickedUp:
		card.reparent(holding_card)
		_update_cards()
	else:
		card.reparent(self)
		_update_cards()

func _update_cards() -> void:
	#getting total size of cards
	var cards := get_child_count()
	var all_cards_size := Card.SIZE.x * cards + x_sep * (cards - 1)
	#fixing the x seperation for the total cards size
	var final_x_sep: float = x_sep
	
	if all_cards_size > size.x:
		final_x_sep = (size.x - Card.SIZE.x * cards) / (cards - 1)
		all_cards_size = size.x
	
	var offset := (size.x - all_cards_size) / 2
	
	for i in cards:
		var card := get_child(i)
		var y_multiplier := hand_curve.sample(1.0 / (cards - 1) * i)
		var rot_multiplier := rotation_curve.sample(1.0 / (cards - 1) * i)
		
		if cards == 1:
			y_multiplier = 0.0
			rot_multiplier = 0.0
		
		var final_x: float = offset + Card.SIZE.x * i + final_x_sep * i
		var final_y: float = y_min + y_max * y_multiplier
		
		card.position = Vector2(final_x, final_y)
		card.rotation_degrees = max_rotation_degrees * rot_multiplier
