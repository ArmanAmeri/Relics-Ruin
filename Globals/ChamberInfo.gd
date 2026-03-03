extends Node

# Chamber Signals

signal deckCountChanged(newCount, oldCount) 
signal escapeCostChange(change)
signal changeBurnText()

#  Chamber Values

@export var chamber: String
@export var difficulty: int
@export var totalCards: int
@export var entryCost: int

@export var deckCards: Array
@export var deckCount: int
@export var deckTotal: int

@export var pot: int
@export var debt: int
@export var handCapacity: int
@export var escapeCost: float
@export var burnCost: int
@export var burnGrowth: float

# Overlay Cords
var useCardDest: Vector2
var burnCardDest: Vector2
var inspectCardDest: Vector2

# Chamber Commands

func setChamberInfo(chamberID: String) -> void:
	chamber = chamberID
	entryCost = IL.get_item_info(chamber, "entryCost")
	difficulty = IL.get_item_info(chamber, "difficulty")
	totalCards = 0
	pot = entryCost
	debt = 0
	handCapacity = 3
	escapeCost = 0
	burnCost = 10
	burnGrowth = 2.5
	deckCount = 0
	deckTotal = IL.get_item_info(chamber, "deck_count")
	deckCards = IL.get_item_info(chamber, "deck_cards")
	
	# Change Main Scene To Chamber
	get_tree().change_scene_to_file("res://Scenes/chamber.tscn")

func chamberDone() -> void:
	# Change Chamber to Chamber Done
	get_tree().change_scene_to_file("res://Scenes/chamber_done.tscn")

func setDeckCount(newCount: int) -> void:
	var oldCount = deckCount
	deckCountChanged.emit(newCount, oldCount)
	deckTotal = deckTotal + (newCount - oldCount)
	escapeCostChange.emit("add")

func setTotalCards(action, amount) -> void:
	if action == "add":
		totalCards += amount
		#escapeCostChange.emit("add") NEEDS SOME MORE WORK TO FIX THE REPEATING CHANGE OF COST
	elif action == "subtract":
		totalCards -= amount
		escapeCostChange.emit("subtract")
	else:
		push_error("Incorrect Action")
	
	if totalCards <= 0:
		#chamberDone()
		print("GAME DONE")

func setBurnCost(value) -> void:
	if value < 0:
		burnCost = 0
	else:
		burnCost = value
	changeBurnText.emit()
