extends Label

@export var enable: bool = false
@export var update_interval := 0.3

var can_update := true

func _ready() -> void:
	SignalBus.mouseSpeed.connect(on_change)

func on_change(speed) -> void:
	if not enable or not can_update:
		return

	text = "Mouse Speed: " + str(round(speed * 100.0) / 100.0)
	can_update = false

	await get_tree().create_timer(update_interval).timeout
	can_update = true
