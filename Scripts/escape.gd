extends Control

@onready var costLabel: Label = $EscapeCostLabel

@export var start_escape_cost: float = 99
@export var min_escape_cost: float = 0.0
@export var curve_exponent: float = 1.0  # 1.0 = linear

func _ready() -> void:
	# Start with full penalty
	update_escape_cost()

	# React whenever cards are added/removed
	ChamberInfo.escapeCostChange.connect(_on_escape_cost_change)

func escape() -> void:
	ChamberInfo.pot = roundi(ChamberInfo.pot * (1 - ChamberInfo.escapeCost / 100.0))
	ChamberInfo.chamberDone()

func _on_escape_cost_change(_change: String) -> void:
	update_escape_cost()

func update_escape_cost() -> void:
	# Use max to ensure total is never less than totalCards
	#var total = max(ChamberInfo.deckTotal, ChamberInfo.totalCards, 1)
	#var remaining = clamp(ChamberInfo.totalCards, 0, total)

	#var cards_played = total - remaining
	var cardsPlayed =  clamp((ChamberInfo.deckTotal - ChamberInfo.totalCards), 0, ChamberInfo.deckTotal)

	var progress = float(cardsPlayed) / float(ChamberInfo.deckTotal)
	progress = pow(progress, curve_exponent)

	var escape_cost = start_escape_cost * (1.0 - progress)
	escape_cost = clamp(escape_cost, min_escape_cost, start_escape_cost)

	ChamberInfo.escapeCost = escape_cost
	changeCostLabel()

func changeCostLabel() -> void:
	costLabel.text = "Cost: -%.1f%%" % ChamberInfo.escapeCost
