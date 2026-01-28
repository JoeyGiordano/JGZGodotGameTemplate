extends Node

func _ready() -> void:
	var speed = 10
	
	var size = 7
	for coord in HexManager.get_coords_in_hexagon(size) :
		var h = HexManager.create_hex(coord,BaseHex.CREATE_TYPE.FADE_IN)
		await get_tree().create_timer(0.05/speed).timeout
		if coord.x == 0 and coord.y == 0 :
			h.modulate = Color.DARK_SLATE_GRAY
	
	#demostrate move (with type slide)
	await get_tree().create_timer(1.0/speed).timeout
	#HexManager.get_hex(Vector2(0,0)).move_(6,-6,BaseHex.MOVE_TYPE.SLIDE)
	
	#demostrate remove (with type fade)
	await get_tree().create_timer(1.0/speed).timeout
	#HexManager.get_hex(Vector2(3,-2)).remove_from_map(BaseHex.REMOVE_TYPE.FADE_OUT)
	
	#demonstrate contiguous conditional
	await get_tree().create_timer(1.0).timeout
	#var cc = await HexManager.get_adjacent_conditional(Vector2i(-3,-2),test_condition)
	var cc = await HexManager.get_contiguous_conditional(Vector2i(0,0),test_condition,false)
	#var cc = HexManager.get_nth_nearest_neighbors_hexes(4, Vector2i(0,0))
	await get_tree().create_timer(0.5).timeout
	for hex in cc :
		hex.modulate = Color.GREEN
		

func test_condition(hex: BaseHex) -> bool :
	hex.modulate = Color.BLUE
	 #TODO remove awaits (also in HexManager)
	await get_tree().create_timer(0.03).timeout
	#if hex.debug_id % 4 == 0 || hex.debug_id % 5 == 0 || hex.debug_id % 6 == 0 :
	if hex.debug_id % 3 == 0 || hex.debug_id % 7 == 0|| randf() < 0.18 :
		hex.modulate = Color.YELLOW_GREEN
		return true
	hex.modulate = Color.RED
	return false
