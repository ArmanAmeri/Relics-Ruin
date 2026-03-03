extends Label

@export var enable: bool = false

func _ready() -> void:
	SignalBus.swiped.connect(on_change)


func on_change(dir) -> void:
	if not enable: return
	text = dir
