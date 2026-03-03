extends Control

const CARD = preload("res://Scenes/card.tscn")

@onready var card_placement: Control = $CardPlacement
@onready var background: Button = $Background

var cardTemplate: Card = null

func _ready() -> void:
	SignalBus.cardZoom.connect(_on_card_zoom)
	
	#toggleVisibility()

func _on_card_zoom(card: Card) -> void:
	if cardTemplate:
		# it exists
		cardTemplate.cardID = IL.get_item_info(card.cardID, "ID")
	else:
		# make the card
		cardTemplate = CARD.instantiate()
		cardTemplate.process_mode = Node.PROCESS_MODE_DISABLED
		cardTemplate.scale = Vector2(3, 3)
		cardTemplate.global_position = card_placement.global_position
		cardTemplate.cardID = IL.get_item_info(card.cardID, "ID")
		background.add_child(cardTemplate)
	toggleVisibility()

func toggleVisibility() -> void:
	visible = !visible

func _on_background_pressed() -> void:
	toggleVisibility()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if visible: return 
	var card: Card = area.get_parent()
	SignalBus.overlayToggle.emit()
	_on_card_zoom(card)
