extends Control

@onready var statisticLabel: RichTextLabel = $StatisticLabel

var profits: int

func _ready() -> void:
	calculateProfits()
	writeStatisticsLabel()

func calculateProfits() -> void:
	profits = ChamberInfo.pot - ChamberInfo.entryCost

func writeStatisticsLabel() -> void:
	statisticLabel.text = '''
	Difficulty:----------> %d
	Entry Pot:-----------> %d
	Profit:--------------> %d
	Debt Increase: ------> %d
	Starting Deck Total:-> %d
	Deck Total:----------> %d
	''' % [ChamberInfo.difficulty, ChamberInfo.entryCost, profits, ChamberInfo.debt, IL.get_item_info(ChamberInfo.chamber, "deck_count"), ChamberInfo.deckTotal]

func calculateResults() -> void:
	if ChamberInfo.pot < 0:
		GameData.subtractWallet(abs(ChamberInfo.pot))
	else:
		GameData.addWallet(ChamberInfo.pot)# NEEDS MORE WORK
	GameData.debt += ChamberInfo.debt
	
	# Change Chamber to Main Scene
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
