extends Node

func _ready() -> void:

	#display hex centers, +x=red, -y=green, (0,0)=white
	for i in range(-6, 5) :
		for j in range(-6, 5) :
			HexManager.create_hex_xy(i,j)
			#if i == 0 and j == 0 :
				#t.modulate.r = 1
				#t.modulate.g = 1
				#t.modulate.b = 1
	
