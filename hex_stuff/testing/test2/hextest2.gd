extends Node

func _ready() -> void:
	var size = 5
	for coord in HexManager.get_coords_in_hexagon(size) :
		var h = HexManager.create_hex(coord)
		await get_tree().create_timer(0.05).timeout
		if coord.x == 0 and coord.y == 0 :
			h.modulate.r = 0
			h.modulate.g = 0
			h.modulate.b = 0
			await get_tree().create_timer(1).timeout
			HexManager.get_hex(Vector2(0,0)).move_(6,-6)
	
