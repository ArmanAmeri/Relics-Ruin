extends Resource

class_name rarityManager

var rng = RandomNumberGenerator.new()
var rarities = IL.rarity

func get_rarity():
	rng.randomize()
	
	var weighted_sum = 0
	
	for n in rarities:
		weighted_sum += rarities[n]
	
	var item = rng.randi_range(0, weighted_sum)
	
	for n in rarities:
		if item <= rarities[n]:
			return n
		item -= rarities[n]
