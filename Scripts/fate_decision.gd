extends Panel

signal choiceMade(choice, cardID)

const FATE_CHOICE_BUTTON = preload("res://Scenes/fate_choice_button.tscn")

@onready var flow_container: FlowContainer = $FlowContainer

func toggleVisibility() -> void:
	visible = !visible

func createChoice(choiceID: int, desc: String, cardID) -> void:
	var choice = FATE_CHOICE_BUTTON.instantiate()
	choice.connect("choiceSelected", choiceSelected)
	choice.setText(desc)
	choice.buttonID = choiceID
	choice.cardID = cardID
	flow_container.add_child(choice)

func choiceSelected(buttonID, cardID) -> void:
	print("BUTTON PRESSED: ", buttonID)
	resetButtons()
	choiceMade.emit(buttonID, cardID)

func resetButtons() -> void:
	for button in flow_container.get_children():
		button.call_deferred("queue_free")
	toggleVisibility()
