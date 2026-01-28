extends Node

func _ready() -> void:

	#display hex centers, +x=red, -y=green, (0,0)=white
	var size = 5
	for i in range(-size, size+1) :
		for j in range(-size, size+1) :
			if abs(i+j)>size: # use this condition to form a perfect hexagon
				continue #skip this cycle of the for loop
			var h = HexManager.create_hex_(i,j)
			if i == 0 and j == 0 :
				h.modulate.r = 0
				h.modulate.g = 0
				h.modulate.b = 0
				#HexManager.get_hex(Vector2(0,0)).remove_from_map() $move_(6,-6)
	
