extends Node

class_name ItemLibrary

enum actions {ADD, SUBTRACT, MULTIPLY, DIVIDE}
enum rarity {COMMON = 700, UNCOMMON = 200, RARE = 80, EPIC = 15, LEGENDARY = 5}
enum cardType {TREASURE, TRAP, CURSE, FATE, WAGER}
enum target {POT, DEBT, DECKCOUNT, HANDCAPACITY, ESCAPECOST, BURNCOST}

const image = preload("res://Assets/Cards/card_v4.png")

const Library:  Dictionary = {
	
	# // RARITY COLORS //
	"common": {
		"ID": "common",
		"item_type": "rarityColor",
		"rarity": rarity.COMMON,
		"color": "#B9F18C"
	},
	
	"uncommon": {
		"ID": "uncommon",
		"item_type": "rarityColor",
		"rarity": rarity.UNCOMMON,
		"color": "#57B8FF"
	},
	
	"rare": {
		"ID": "rare",
		"item_type": "rarityColor",
		"rarity": rarity.RARE,
		"color": "#D33F49"
	},
	
	"epic": {
		"ID": "epic",
		"item_type": "rarityColor",
		"rarity": rarity.EPIC,
		"color": "#392F5A"
	},
	
	"legendary": {
		"ID": "legendary",
		"item_type": "rarityColor",
		"rarity": rarity.LEGENDARY,
		"color": "#FFC300"
	},
	
	
	#  //CARDS//
	
	
	# Treasure Cards
	
	"loose_change": {
		"ID": "loose_change",
		"title": "Loose Change",
		"texture": image,
		"action": actions.ADD,
		"value": 5,
		"target": target.POT,
		"item_type": "card",
		"card_desc": "+5G",
		"rarity": rarity.COMMON,
		"cardtype": cardType.TREASURE,
	},
	
	"coin_pouch": {
		"ID": "coin_pouch",
		"title": "Coin Pouch",
		"texture": image,
		"action": actions.ADD,
		"value": 25,
		"target": target.POT,
		"item_type": "card",
		"card_desc": "+25G",
		"rarity": rarity.UNCOMMON,
		"cardtype": cardType.TREASURE,
	},
	
	"treasure_chest": {
		"ID": "treasure_chest",
		"title": "Treasure Chest",
		"texture": image,
		"action": actions.MULTIPLY,
		"value": 2,
		"target": target.POT,
		"item_type": "card",
		"card_desc": "x2G",
		"rarity": rarity.LEGENDARY,
		"cardtype": cardType.TREASURE,
	},

	
	# Trap Cards
	
	"nibbler": {
		"ID": "nibbler",
		"title": "Nibbler",
		"texture": image,
		"action": actions.SUBTRACT,
		"value": 10,
		"target": target.POT,
		"item_type": "card",
		"card_desc": "-10G",
		"rarity": rarity.COMMON,
		"cardtype": cardType.TRAP,
	},
	
	"wallet_mimic": {
		"ID": "wallet_mimic",
		"title": "Wallet Mimic",
		"texture": image,
		"action": actions.SUBTRACT,
		"value": 50,
		"target": target.POT,
		"item_type": "card",
		"card_desc": "-50G",
		"rarity": rarity.RARE,
		"cardtype": cardType.TRAP,
	},

	"leaking_oil_barrel": {
		"ID": "leaking_oil_barrel",
		"title": "Leaking Oil Barrel",
		"texture": image,
		"action": actions.ADD,
		"value": 50,
		"target": target.BURNCOST,
		"item_type": "card",
		"card_desc": "+50 Burn",
		"rarity": rarity.EPIC,
		"cardtype": cardType.TRAP,
	},
	
	# Wager Cards
	
	"coin_flip": {
		"ID": "coin_flip",
		"title": "Coin Flip",
		"texture": image,
		"wager_options": {
			1: {
				"chance": 50,
				"action": actions.SUBTRACT,
				"value": 50,
				"target": target.POT,
				"desc": "-50G",
			},
			2: {
				"chance": 50,
				"action": actions.ADD,
				"value": 50,
				"target": target.POT,
				"desc": "+50G",
			},
		},
		"item_type": "card",
		"rarity": rarity.UNCOMMON,
		"cardtype": cardType.WAGER,
	},
	
	"double_or_nothing": {
		"ID": "double_or_nothing",
		"title": "Double or Nothing",
		"texture": image,
		"wager_options": {
			1: {
				"chance": 50,
				"action": actions.MULTIPLY,
				"value": 2,
				"target": target.POT,
				"desc": "x2G",
			},
			2: {
				"chance": 50,
				"action": actions.SUBTRACT,
				"value": 99999,
				"target": target.POT,
				"desc": "Lose All G",
			},
		},
		"item_type": "card",
		"rarity": rarity.EPIC,
		"cardtype": cardType.WAGER,
	},
 
	"loaded_dice": {
		"ID": "loaded_dice",
		"title": "Loaded Dice",
		"texture": image,
		"wager_options": {
			1: {
				"chance": 70,
				"action": actions.ADD,
				"value": 10,
				"target": target.POT,
				"desc": "+10G",
			},
			2: {
				"chance": 30,
				"action": actions.SUBTRACT,
				"value": 50,
				"target": target.POT,
				"desc": "-50G",
			},
		},
		"item_type": "card",
		"rarity": rarity.COMMON,
		"cardtype": cardType.WAGER,
	},

	
	# Curse Cards
	
	"dead_coin": {
		"ID": "dead_coin",
		"title": "Dead Coin",
		"texture": image,
		"curse_options": {
			1: {
				"action": actions.MULTIPLY,
				"value": 1.2,
				"target": target.POT,
				"desc": "+20%G",
			},
			2: {
				"action": actions.SUBTRACT,
				"value": 1,
				"target": target.HANDCAPACITY,
				"desc": "-1 Hand",
			},
		},
		"item_type": "card",
		"rarity": rarity.UNCOMMON,
		"cardtype": cardType.CURSE,
	},
	
	
	"protein_shake": {
		"ID": "protein_shake",
		"title": "Protein Shake",
		"texture": image,
		"curse_options": {
			1: {
				"action": actions.ADD,
				"value": 2,
				"target": target.HANDCAPACITY,
				"desc": "+2 Hand",
			},
			2: {
				"action": actions.SUBTRACT,
				"value": 100,
				"target": target.POT,
				"desc": "-100G",
			},
		},
		"item_type": "card",
		"rarity": rarity.RARE,
		"cardtype": cardType.CURSE,
	},

	"bloody_money": {
		"ID": "bloody_money",
		"title": "Bloody Money",
		"texture": image,
		"curse_options": {
			1: {
				"action": actions.ADD,
				"value": 25,
				"target": target.POT,
				"desc": "+25G",
			},
			2: {
				"action": actions.ADD,
				"value": 20,
				"target": target.DEBT,
				"desc": "+20D",
			},
		},
		"item_type": "card",
		"rarity": rarity.COMMON,
		"cardtype": cardType.CURSE,
	},
	
	
	# Fate Cards
	
	"forked_path": {
		"ID": "forked_path",
		"title": "Forked Path",
		"texture": image,
		"fate_options": {
			1: {
				"id": 1,
				"action": actions.ADD,
				"value": 15,
				"target": target.POT,
				"desc": "+15G",
			},
			2: {
				"id": 2,
				"action": actions.SUBTRACT,
				"value": 15,
				"target": target.DEBT,
				"desc": "-15D",
			},
		},
		"item_type": "card",
		"rarity": rarity.COMMON,
		"cardtype": cardType.FATE,
	},

	"omens_eye": {
		"ID": "omens_eye",
		"title": "Omen’s Eye",
		"texture": image,
		"fate_options": {
			1: {
				"id": 1,
				"action": actions.ADD,
				"value": 1,
				"target": target.DECKCOUNT,
				"desc": "+1 Deck",
			},
			2: {
				"id": 2,
				"action": actions.SUBTRACT,
				"value": 30,
				"target": target.BURNCOST,
				"desc": "-30 Burn",
			},
		},
		"item_type": "card",
		"rarity": rarity.UNCOMMON,
		"cardtype": cardType.FATE,
	},

	"final_choice": {
		"ID": "final_choice",
		"title": "Final Choice",
		"texture": image,
		"fate_options": {
			1: {
				"id": 1,
				"action": actions.ADD,
				"value": 1,
				"target": target.HANDCAPACITY,
				"desc": "+1 Hand",
			},
			2: {
				"id": 2,
				"action": actions.SUBTRACT,
				"value": 50,
				"target": target.DEBT,
				"desc": "-50D",
			},
		},
		"item_type": "card",
		"rarity": rarity.RARE,
		"cardtype": cardType.FATE,
	},
	
	"golden_pedestal": {
		"ID": "golden_pedestal",
		"title": "Golden Pedestal",
		"texture": image,
		"fate_options": {
			1: {
				"id": 1,
				"action": actions.ADD,
				"value": 300,
				"target": target.POT,
				"desc": "+300G",
			},
			2: {
				"id": 2,
				"action": actions.ADD,
				"value": 5,
				"target": target.DECKCOUNT,
				"desc": "+5 Deck",
			},
			3: {
				"id": 3,
				"action": actions.SUBTRACT,
				"value": 250,
				"target": target.DEBT,
				"desc": "-250D",
			},
		},
		"item_type": "card",
		"rarity": rarity.LEGENDARY,
		"cardtype": cardType.FATE,
	},

	
	
	#  //CHAMBERS//
	
	"test": {
		"ID": "test",
		"title": "test",
		"item_type": "chamber",
		"deck_count": 5,
		"deck_cards": [

			],
		"difficulty": 1,
		"entryCost": 100,
	},
	
	"old_ruins": {
		"ID": "old_ruins",
		"title": "Old Ruins",
		"item_type": "chamber",
		"deck_count": 12,
		"deck_cards": [
			"loose_change",  
			"coin_pouch",
			"treasure_chest",
			"nibbler",
			"wallet_mimic",
			"leaking_oil_barrel",
			"coin_flip",
			"double_or_nothing",
			"loaded_dice",
			"dead_coin",
			"protein_shake",
			"bloody_money",
			"forked_path",
			"omens_eye",
			"final_choice",
			"golden_pedestal",
			],
		"difficulty": 1,
		"entryCost": 100,
	},
	
} 


func get_item_info(item_name: String, info: String):
	#print("")
	#print("Item Name: ", item_name, " | Requested Item Info: ", info)
	for item in Library:
		if item == item_name:
			if info in Library[item]:
				#print("Retrieved Info: ", Library[item][info])
				#print("")
				#print("-----------------------------")
				return Library[item][info]
			else:
				return Library[item]
	
	print("Item Not Found: ", item_name, " | Item Info: ", info)
	return null


func get_rarity_id(rarity_value: int) -> String:
	match rarity_value:
		rarity.COMMON: return "common"
		rarity.UNCOMMON: return "uncommon"
		rarity.RARE: return "rare"
		rarity.EPIC: return "epic"
		rarity.LEGENDARY: return "legendary"
		_: return "common"
