extends Node

#  Game Variables

var wallet: int = 1000
var debt: int = 100000


# Game Functions

func addWallet(amount) -> void:
	wallet += amount
	print("WAllET: ", wallet)

func subtractWallet(amount) -> void:
	if wallet >= amount:
		wallet -= amount
		print("WALLET: ", wallet)
	else:
		var remaining = abs(wallet - amount)
		wallet -= wallet
		debt += remaining
		print("WALLET Insufficient, Adding to Debt")
		print("WALLET: ", wallet)
		print("DEBT: ", debt)
