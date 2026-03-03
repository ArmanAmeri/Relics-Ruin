extends Control

@onready var use_pos: Marker2D = $Use/UsePos
@onready var burn_pos: Marker2D = $Burn/BurnPos
@onready var inspect_pos: Marker2D = $Inspect/InspectPos

func _ready() -> void:
	#overlayToggle()
	SignalBus.overlayToggle.connect(overlayToggle)
	
	ChamberInfo.useCardDest = use_pos.global_position
	ChamberInfo.burnCardDest = burn_pos.global_position
	ChamberInfo.inspectCardDest = inspect_pos.global_position

func overlayToggle() -> void:
	visible = !visible
