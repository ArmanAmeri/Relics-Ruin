extends Button
class_name FateButton

signal choiceSelected(buttonID, cardID)

var buttonID: int
var cardID

func setText(labelText: String) -> void:
	text = labelText

func _on_pressed() -> void:
	choiceSelected.emit(buttonID, cardID)
