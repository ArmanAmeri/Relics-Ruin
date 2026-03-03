extends Node

var current_scene: Node = null


func _ready() -> void:
	start_MainMenu()


# --------------------------------------------------
# PUBLIC
# --------------------------------------------------

func start_MainMenu() -> void:
	_change_scene("res://Scenes/MainMenu.tscn")


func start_Chamber() -> void:
	_change_scene("res://Scenes/Chamber.tscn")

func start_ChamberDone() -> void:
	_change_scene("res://Scenes/chamber_done.tscn")

func change_scene(scene_path: String) -> void:
	_change_scene(scene_path)


# --------------------------------------------------
# INTERNAL
# --------------------------------------------------

func _change_scene(scene_path: String) -> void:
	# Remove previous scene
	if current_scene:
		current_scene.queue_free()
		current_scene = null

	var scene_resource := load(scene_path)
	current_scene = scene_resource.instantiate()
	add_child(current_scene)
