extends Node2D

var tp := preload("res://hex_stuff/testing/test1/testpoint.tscn")
var grid = HexGrid.new(50)

func _ready() -> void:
	# proves that real_to_grid_nearestv() and grid_to_real() work!
	
	#display background, +x=red, -y=green
	var spacing = 3
	for i in range(-50, 100) :
		for j in range(-100, 50) :
			var t : Node2D = tp.instantiate()
			add_child(t)
			t.position = Vector2(spacing*i,spacing*j)
			var q = grid.real_to_grid_nearestv(t.position)
			t.modulate.r = float(q.x)/3
			t.modulate.g = float(q.y)/3
			t.modulate.b = 0
				
	#display hex centers, +x=red, -y=green, (0,0)=white
	for i in range(-6, 5) :
		for j in range(-6, 5) :
			var t : Node2D = tp.instantiate()
			add_child(t)
			t.position = grid.grid_to_real(i,j)
			t.modulate.r = float(i)/3
			t.modulate.g = float(j)/3
			t.modulate.b = 0
			if i == 0 and j == 0 :
				t.modulate.r = 1
				t.modulate.g = 1
				t.modulate.b = 1
	
