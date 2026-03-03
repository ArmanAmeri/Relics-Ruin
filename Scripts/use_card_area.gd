extends Label
class_name CardCalc

@onready var hand: Hand = $"../../Hand"
@onready var fateDecision: Panel = $"../../FateDecision"

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	fateDecision.connect("choiceMade", fate_calc)

func _on_area_2d_area_entered(area):
	var card: Card = area.get_parent()
	
	use_card_calculation(card)
	
	if not card.get_parent() == Deck:
		card.destroy()
		hand.curCards -= 1
	
	SignalBus.overlayToggle.emit()

func use_card_calculation(card: Card) -> void:
	if IL.get_item_info(card.cardID, "cardtype") == IL.cardType.WAGER:
		wager_calc(card)
	elif IL.get_item_info(card.cardID, "cardtype") == IL.cardType.CURSE:
		curse_calc(card)
	elif IL.get_item_info(card.cardID, "cardtype") == IL.cardType.FATE:
		fate_init(card)
	else:
		var action = IL.get_item_info(card.cardID, "action")
		var value = IL.get_item_info(card.cardID, "value")
		var target = IL.get_item_info(card.cardID, "target")
		
		modify_target(target, value, action)

func wager_calc(card: Card) -> void:
	var options = IL.get_item_info(card.cardID, "wager_options")
	var wagerList: Dictionary = {}
	for item in options:
		wagerList[item] = options[item]["chance"]
	var chosenItem = wagerChance(wagerList)
	for item in options:
		if item == chosenItem:
			modify_target(options[item]["target"], options[item]["value"], options[item]["action"])

func curse_calc(card: Card) -> void:
	var options = IL.get_item_info(card.cardID, "curse_options")
	for item in options:
		modify_target(options[item]["target"], options[item]["value"], options[item]["action"])

func fate_init(card: Card) -> void:
	fateDecision.toggleVisibility()
	var options = IL.get_item_info(card.cardID, "fate_options")
	for item in options:
		fateDecision.createChoice(options[item]["id"], options[item]["desc"], card.cardID)

func fate_calc(choice, cardID) -> void:
	var options = IL.get_item_info(cardID, "fate_options")
	for item in options:
		if item == choice:
			modify_target(options[item]["target"], options[item]["value"], options[item]["action"])

func modify_target(target, value: int, op: IL.actions) -> void:
	match target:
		IL.target.POT:
			if value == 99999:
				value = ChamberInfo.pot
			match op:
				IL.actions.ADD: ChamberInfo.pot += value
				IL.actions.SUBTRACT: ChamberInfo.pot -= value
				IL.actions.MULTIPLY: ChamberInfo.pot = roundi(ChamberInfo.pot * value)
				IL.actions.DIVIDE: ChamberInfo.pot = roundi(float(ChamberInfo.pot) / value)
		IL.target.DEBT:
			if value == 99999:
				value = ChamberInfo.debt
			match op:
				IL.actions.ADD: ChamberInfo.debt += value
				IL.actions.SUBTRACT: ChamberInfo.debt -= value
				IL.actions.MULTIPLY: ChamberInfo.debt *= value
				IL.actions.DIVIDE: ChamberInfo.debt /= value
		IL.target.DECKCOUNT:
			if value == 99999:
				value = ChamberInfo.deckCount
			match op:
				IL.actions.ADD: ChamberInfo.setDeckCount(ChamberInfo.deckCount + value)
				IL.actions.SUBTRACT: ChamberInfo.setDeckCount(ChamberInfo.deckCount - value)
				IL.actions.MULTIPLY: ChamberInfo.setDeckCount(ChamberInfo.deckCount * value)
				IL.actions.DIVIDE: ChamberInfo.setDeckCount(roundi(float(ChamberInfo.deckCount) / value))
		IL.target.HANDCAPACITY:
			if value == 99999:
				value = ChamberInfo.handCapacity
			match op:
				IL.actions.ADD: ChamberInfo.handCapacity += value
				IL.actions.SUBTRACT: ChamberInfo.handCapacity -= value
				IL.actions.MULTIPLY: ChamberInfo.handCapacity *= value
				IL.actions.DIVIDE: ChamberInfo.handCapacity /= value
		IL.target.ESCAPECOST:
			if value == 99999:
				value = roundi(ChamberInfo.escapeCost)
			match op:
				IL.actions.ADD: ChamberInfo.escapeCost += value
				IL.actions.SUBTRACT: ChamberInfo.escapeCost -= value
				IL.actions.MULTIPLY: ChamberInfo.escapeCost *= value
				IL.actions.DIVIDE: ChamberInfo.escapeCost /= value
		IL.target.BURNCOST:
			if value == 99999:
				value = ChamberInfo.burnCost
			match op:
				IL.actions.ADD: ChamberInfo.setBurnCost(ChamberInfo.burnCost + value)
				IL.actions.SUBTRACT: ChamberInfo.setBurnCost(ChamberInfo.burnCost - value)
				IL.actions.MULTIPLY: ChamberInfo.setBurnCost(ChamberInfo.burnCost * value)
				IL.actions.DIVIDE: ChamberInfo.setBurnCost(roundi(float(ChamberInfo.burnCost) / value))
		_:
			print("target not found")
	print("---------------------------")
	print("CHAMBER STAT CHANGE")
	print("Pot: ", ChamberInfo.pot)
	print("Debt: ", ChamberInfo.debt)
	print("DeckCount: ", ChamberInfo.deckCount)
	print("DeckTotal: ", ChamberInfo.deckTotal)
	print("Hand: ", ChamberInfo.handCapacity)
	print("EscapeCost: ", ChamberInfo.escapeCost)
	print("BurnCost: ", ChamberInfo.burnCost)
	print("---------------------------")

func wagerChance(wagerList):
	
	rng.randomize()
	
	var weighted_sum = 0
	
	for n in wagerList:
		weighted_sum += wagerList[n]
	
	var item = rng.randi_range(0, weighted_sum)
	
	for n in wagerList:
		if item <= wagerList[n]:
			return n
		item -= wagerList[n]
