extends Control
class_name Deck

const CARD = preload("res://Scenes/card.tscn")

@onready var hand: Hand = $"../Hand"

@export var controlPoint: float = 400
@export var start_rotation: float = -55
@export var rarityM: rarityManager

var CardMoveTween: Tween

var drawing_card: bool = false
var rng = RandomNumberGenerator.new()

var common: int = 0
var uncommon: int = 0
var rare: int = 0
var epic: int = 0
var legendary: int = 0
var cursed: int = 0

func _ready() -> void:
	ChamberInfo.deckCountChanged.connect(deckCountChange)
	create_chamber()

func _on_draw_pressed() -> void:
	if hand.curCards >= ChamberInfo.handCapacity: return
	if not drawing_card:
		if get_child_count() > 0:
			drawing_card = true
			var last_card = get_child(-1)
			
			# OLD Animate Moving The Card
			#if CardMoveTween and CardMoveTween.is_running():
			#	CardMoveTween.kill()
			#CardMoveTween = create_tween()
			#CardMoveTween.set_trans(Tween.TRANS_EXPO)
			#CardMoveTween.tween_property(last_card, "global_position", handDropoffPos - (Vector2(128, 192)/2), 0.5)
			#await CardMoveTween.finished
			
			# Animate Moving The Card
			var orginalPos: Vector2 = last_card.global_position
			var targetPos: Vector2 = Vector2(orginalPos.x + 50, orginalPos.y + 430)
			var curvePos: Vector2 = Vector2(((targetPos.x + orginalPos.x) / 2 ) + controlPoint,((targetPos.y + orginalPos.y) / 2 ))
			
			if CardMoveTween and CardMoveTween.is_running():
				CardMoveTween.kill()
			CardMoveTween = create_tween().set_parallel().set_trans(Tween.TRANS_EXPO)
			CardMoveTween.tween_method(func(t):
				var pos = _quadratic_bezier(orginalPos, curvePos, targetPos, t)
				last_card.global_position = pos
				
				if last_card.global_position.x == curvePos.x:
					last_card.rotation_degrees = 0
				# rotation lerp (in radians)
				#var start_rot = deg_to_rad(start_rotation)
				#var end_rot = deg_to_rad(0)
				#last_card.rotation = lerp_angle(start_rot, end_rot, t)
			, 0.0, 1.0, 0.7)
			CardMoveTween.tween_property(last_card, "rotation_degrees", 3, 0.4).set_delay(0.15)
			
			await CardMoveTween.finished

			# Draw card = reparent and organize
			hand.draw(last_card)
			ChamberInfo.deckCount -= 1
			
			drawing_card = false

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r

func create_chamber() -> void:
	var total_cards: int = ChamberInfo.deckTotal
	var difficulty: int = ChamberInfo.difficulty
	print("This Chambers Difficulty: ", difficulty, " Star")
	
	createCards(total_cards)

func deckCountChange(newCount, oldCount) -> void:
	print("deck count change")
	var amount = abs(newCount - oldCount)
	if newCount > oldCount:
		createCards(amount)
	elif newCount < oldCount:
		if get_child_count() == 0: return
		for i in range(amount):
			var firstChild = get_child(0)
			firstChild.destroy()
			ChamberInfo.deckCount -= 1
	else:
		print("Error at deckCountChange")

func check_for_card_rarity(deck, cardRarity):
	var cards: Array = []

	for card in deck:
		var card_rarity = IL.get_item_info(card, "rarity")
		if card_rarity == cardRarity:
			cards.append(card)

	if cards.is_empty():
		push_error("No cards with rarity: %s" % cardRarity)

	return cards

func createCards(amount: int) -> void:
	rng.randomize()
	var deck_cards: Array = ChamberInfo.deckCards 
	var deck: Array
	
	for i in range(amount):
		var rarity: String = rarityM.get_rarity()
		
		if rarity == "COMMON":
			common += 1
			var cards: Array = check_for_card_rarity(deck_cards, IL.rarity.COMMON)
			if cards.size() > 0:
				var randomCard: int = rng.randi_range(0, cards.size() - 1)
				deck.append(cards[randomCard])

		elif rarity == "UNCOMMON":
			uncommon += 1
			var cards: Array = check_for_card_rarity(deck_cards, IL.rarity.UNCOMMON)
			if cards.size() > 0:
				var randomCard: int = rng.randi_range(0, cards.size() - 1)
				deck.append(cards[randomCard])
			
		elif rarity == "RARE":
			rare += 1
			var cards: Array = check_for_card_rarity(deck_cards, IL.rarity.RARE)
			if cards.size() > 0:
				var randomCard: int = rng.randi_range(0, cards.size() - 1)
				deck.append(cards[randomCard])
			
		elif rarity == "EPIC":
			epic += 1
			var cards: Array = check_for_card_rarity(deck_cards, IL.rarity.EPIC)
			if cards.size() > 0:
				var randomCard: int = rng.randi_range(0, cards.size() - 1)
				deck.append(cards[randomCard])
			
		elif rarity == "LEGENDARY":
			legendary += 1
			var cards: Array = check_for_card_rarity(deck_cards, IL.rarity.LEGENDARY)
			if cards.size() > 0:
				var randomCard: int = rng.randi_range(0, cards.size() - 1)
				deck.append(cards[randomCard])

	for card in deck:
		# INITILAZE CARDS
		var new_card = CARD.instantiate()
		new_card.cardID = IL.get_item_info(card, "ID")
		ChamberInfo.deckCount += 1
		self.add_child(new_card)
		
		# Change Pos
		#new_card.position.x += (get_child_count() * -1)
		new_card.position.y += (get_child_count() * -2)
		new_card.rotation_degrees = start_rotation
		
	print("The Deck Count is: ", ChamberInfo.deckCount)
	print("The Total Deck is: ", ChamberInfo.deckTotal)
	print("The Total Cards is: ", ChamberInfo.totalCards	)
	print("common: ", common)
	print("uncommon: ", uncommon)
	print("rare: ", rare)
	print("epic: ", epic)
	print("legendary: ", legendary)
	print("------------------------")
