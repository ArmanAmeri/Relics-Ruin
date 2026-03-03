extends Control

@onready var walletLabel: Label = $TopBar/HBoxContainer/WalletLabel
@onready var debtLabel: Label = $TopBar/HBoxContainer/DebtLabel


@export var chamber: String = "old_ruins"


func _ready() -> void:
	updateMoneyValues()

func enterChamber() -> void:
	if GameData.wallet < ChamberInfo.entryCost:
		print("Not Enough Money!!")
		return
	else:
		GameData.subtractWallet(IL.get_item_info(chamber, "entryCost"))
		ChamberInfo.setChamberInfo(chamber)

func updateMoneyValues() -> void:
	walletLabel.text = "Wallet: " + str(GameData.wallet) + " C"
	debtLabel.text = "Debt: " + str(GameData.debt) + " D"
