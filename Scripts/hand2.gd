extends Control

@export var tilt_cards: bool = true

# Controls how spaced the cards are per count
@export var spacing_per_card_deg: float = 10.0 # NOW TO FIX THE DECK
@export var max_angle_range: float = 20.0

# Radius dynamically scales with card count
@export var min_radius: float = 500.0
@export var max_radius: float = 1000.0
@export var cards_for_max_radius: int = 10

func organize_hand() -> void:
	var cards: Array[Node] = get_children()
	var card_count: int = cards.size()
	if card_count == 0:
		return

	# 💡 Dynamic fan angle
	var dynamic_angle_range: float = float(card_count - 1) * spacing_per_card_deg
	var clamped_angle_range: float = min(dynamic_angle_range, max_angle_range)
	var angle_step: float = deg_to_rad(clamped_angle_range) / max(1, card_count - 1)
	var start_angle: float = -deg_to_rad(clamped_angle_range) / 2.0

	# 🌀 Dynamic radius
	var radius_factor: float = clamp(float(card_count) / float(cards_for_max_radius), 0.0, 1.0)
	var radius: float = lerp(min_radius, max_radius, radius_factor)

	for i in range(card_count):
		var angle: float = start_angle + float(i) * angle_step

		var x: float = radius * sin(angle)
		var y: float = angle * angle * radius * 0.25

		var card: Control = cards[i] as Control
		if card == null:
			continue

		card.pivot_offset = card.size / 2
		card.position = Vector2(x, y) + size / 2 - card.pivot_offset
		card.rotation = angle if tilt_cards else 0.0
		card.set_defualt_hover_pos(card.position.y)
