extends Control

@onready var burn_cost_label: Label = $BurnCostLabel
@onready var hand: Hand = $"../Hand"

func _ready() -> void:
	ChamberInfo.changeBurnText.connect(changeLabel)
	changeBurnCost()

func burnCard(area) -> void:
	var card: Card = area.get_parent()
	
	if not card.get_parent() == Deck:
		card.destroy()
		hand.curCards -= 1
	
	SignalBus.overlayToggle.emit()
	
	ChamberInfo.debt += ChamberInfo.burnCost
	changeBurnCost()

func changeBurnCost() -> void:
	var nextBurnCost
	if ChamberInfo.burnCost == 0:
		nextBurnCost = 25
	else:
		nextBurnCost = ChamberInfo.burnCost * ChamberInfo.difficulty * ChamberInfo.burnGrowth
	ChamberInfo.burnCost = round(nextBurnCost)
	changeLabel()

func changeLabel() -> void:
	burn_cost_label.text = "Cost: " + str(ChamberInfo.burnCost) + "D"
