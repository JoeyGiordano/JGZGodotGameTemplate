@tool
extends Node2D

@export var grid : Grid
@export var snap : bool = true
@export_enum("Point", "Square Center", "Edge Centers") var snap_type : int = 0
@export var grid_pos : Vector2

func _process(_delta) :
	if Engine.is_editor_hint() :
		var selected = self in EditorInterface.get_selection().get_selected_nodes() #selected is true if the wall is selected in the editor
		if selected :
			if snap :
				match(snap_type) :
					0 :
						grid_pos = grid.nearest_point(position, Grid.COORD_TYPE.REAL, Grid.COORD_TYPE.GRID)
					1 : 
						grid_pos = grid.nearest_square_center(position, Grid.COORD_TYPE.REAL, Grid.COORD_TYPE.GRID)
					2 : 
						grid_pos = grid.nearest_edge_center(position, Grid.COORD_TYPE.REAL, Grid.COORD_TYPE.GRID)
		position = grid.grid_to_real(grid_pos)
		
