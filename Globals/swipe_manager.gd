extends Node

var length: float = 30
var startPos: Vector2
var CurPos: Vector2
var swiping: bool = false

var threshold: float = 100

var prev_mouse_pos: Vector2
var mouse_speed: float


func _process(delta: float) -> void:
	var current_mouse_pos = get_viewport().get_mouse_position()
	
	var movement = current_mouse_pos - prev_mouse_pos
	
	mouse_speed = movement.length() / delta
	
	prev_mouse_pos = current_mouse_pos
	
	SignalBus.mouseSpeed.emit(mouse_speed)
	
	if Input.is_action_just_pressed("press"):
		if !swiping:
			swiping = true
			startPos = get_viewport().get_mouse_position()
			#print("Start Position: ", startPos)
	if Input.is_action_pressed("press"):
		if swiping:
			CurPos = get_viewport().get_mouse_position()
			if startPos.distance_to(CurPos) >= length:
				#print("Distance Swiped: ", startPos.distance_to(CurPos))
				
				#print((startPos - CurPos).normalized())
				var diff: Vector2 = CurPos - startPos
				var dir: Vector2 = diff.normalized()
				
				# The Cardinal Directions
				if abs(startPos.y - CurPos.y) <= threshold:
					if dir.x >= 0:
						#print("East")
						SignalBus.swiped.emit("East")
						return
					elif dir.x <= 0:
						#print("West")
						SignalBus.swiped.emit("West")
						return
					swiping = false
				elif abs(startPos.x - CurPos.x) <= threshold:
					if dir.y >= 0:
						#print("South")
						SignalBus.swiped.emit("South")
						return
					elif dir.y <= 0:
						#print("North")
						SignalBus.swiped.emit("North")
						return
					swiping = false
					
				# The Ordinal Directions
				else:
					if dir.x >= 0 and dir.y >= 0:
						#print("SE")
						SignalBus.swiped.emit("SE")
						return
					elif dir.x >= 0 and dir.y <= 0:
						#print("NE")
						SignalBus.swiped.emit("NE")
						return
					elif dir.x <= 0 and dir.y <= 0:
						#print("NW")
						SignalBus.swiped.emit("NW")
						return
					elif dir.x <= 0 and dir.y >= 0:
						#print("SW")
						SignalBus.swiped.emit("SW")
						return
					swiping = false
					
	else:
		swiping = false
