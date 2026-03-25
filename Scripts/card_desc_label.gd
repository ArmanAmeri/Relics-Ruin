extends RichTextLabel

@onready var card: Card = $"../../../.."

@export var min_font_size: int = 18
@export var max_font_size: int = 32
@export var padding: int = 5

func _ready():
	card.DescTextChanged.connect(auto_scale_font)
	auto_scale_font()  # Scale on initial load

func auto_scale_font():
	if text.is_empty():
		return
	
	# Binary search for the largest font size that fits
	var low: int = min_font_size
	var high: int = max_font_size
	var best_size: int = min_font_size
	
	while low <= high:
		var mid: int = floori((low + high) / 2.0)
		
		if await fits_at_size(mid):
			best_size = mid
			low = mid + 1
		else:
			high = mid - 1
	
	# Apply the font size
	add_theme_font_size_override("normal_font_size", best_size)

func fits_at_size(font_size: int) -> bool:
	# Temporarily set the size
	add_theme_font_size_override("normal_font_size", font_size)
	
	# Force update to get accurate content size
	await get_tree().process_frame
	
	# Get the content height
	var content_height = get_content_height()
	var available_height = size.y - padding * 2
	
	return content_height <= available_height
