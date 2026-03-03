extends Control

var card_path = load("res://Scenes/card.tscn")
var card_path2 = load("res://Scenes/cardtest.tscn")

@onready var hand: Control = $"../Hand"

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		var new_card: Control = card_path.instantiate()
		hand.add_child(new_card)
		hand.organize_hand() 
		
	if Input.is_action_just_pressed("ui_cancel"):
		var new_card: Control = card_path2.instantiate()
		hand.add_child(new_card)
		hand.organize_hand() 
	
