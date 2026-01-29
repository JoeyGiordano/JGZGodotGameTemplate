extends Node

var speed = 10

func _ready() -> void:
	var size = 2
	for coord in HexManager.get_coords_in_hexagon(size) :
		var h = HexManager.create_hex(coord,BaseHex.CREATE_TYPE.FADE_IN)
		await get_tree().create_timer(0.05/speed).timeout
		if coord.x == 0 and coord.y == 0 :
			h.modulate = Color.DARK_SLATE_GRAY
