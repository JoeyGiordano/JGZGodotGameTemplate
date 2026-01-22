@tool
extends Node2D
class_name Wall

## DO NOT EDIT THIS SCRIPT (things will break. I think you can extend from it though without issue)
# A tool script to easily set the posistion of a wall in the Editor

@export var horizontal : bool = false
@export var color : Color = Color.WHITE
@export var length : float = 100.0
@export var width : float = 8.0

@export_category("Grid")
@export var grid : Grid
@export var snap_to_grid : bool = true
@export var grid_pos : Vector2 = Vector2.ZERO
@export var grid_length : int = 1

#children
@onready var col : CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	update_children_shape()

func _process(_delta):
	if Engine.is_editor_hint() : #only run this code in the editor
		var selected = self in EditorInterface.get_selection().get_selected_nodes() #selected is true if the wall is selected in the editor
		if grid && snap_to_grid : #only snap to grid if there is a grid and snap to grid is true 
			#if its selected, use any changes to position to resnap it and adjust length
			if selected : #only run this code if the node is selected in the editor
				#resnap to the nearest grid position (if its even length)
				if grid_length % 2 == 0 :
					grid_pos = grid.nearest_point(position, Grid.COORD_TYPE.REAL, Grid.COORD_TYPE.GRID)
				#if its and odd length, snap to the nearest middle of the edge (horizontal or vertical based on the orientation of the wall)
				elif horizontal : grid_pos = grid.nearest_horizontal_edge_center(position, Grid.COORD_TYPE.REAL, Grid.COORD_TYPE.GRID)
				else : grid_pos = grid.nearest_vertical_edge_center(position, Grid.COORD_TYPE.REAL, Grid.COORD_TYPE.GRID)
				#take length input
				if Input.is_action_just_pressed("ui_up") && Input.is_key_pressed(KEY_SHIFT) : grid_length += 1
				if Input.is_action_just_pressed("ui_down") && Input.is_key_pressed(KEY_SHIFT) : 
					grid_length -= 1
					if grid_length < 1 : grid_length = 1
			#set the real position and length pased on the snapped info
			position = grid.grid_to_real(grid_pos)
			length = grid_length * grid.scale_ + width
		
		#shortcut to create a new identical wall
		if selected && Input.is_action_just_pressed("ui_focus_next") : #ui_focus_next = tab
			create_new_identical_wall()
		update_children_shape()

func  update_children_shape() :
	#update the variables of the children (sprite and collider) to reflect the length and width in this script
	if horizontal :
		col.shape.size = Vector2(length, width)
		sprite.scale = Vector2(length, width)
	else :
		col.shape.size = Vector2(width, length)
		sprite.scale = Vector2(width, length)
	sprite.position = Vector2.ZERO
	sprite.modulate = color

func create_new_identical_wall() : #call in the editor only
	var ps : PackedScene = load("res://game/wall/wall.tscn")
	var w : Wall = ps.instantiate()
	get_parent().add_child(w, true) #put the wall in the scene tree, renaming it (yes, you can use add sibling, but this will put it at the end which is better with the renaming)
	w.owner = owner #set the new walls owner to the current walls owner (the scene tree root)
	#set all of the wall vars
	w.horizontal = horizontal
	w.color = color
	w.length = length
	w.width = width
	if grid : w.grid = grid
	w.snap_to_grid = snap_to_grid
	w.grid_pos = grid_pos + Vector2(1,1)
	w.grid_length = grid_length
	w.position = position + Vector2(50,50)
	w.rotation = rotation
	#select the new node
	EditorInterface.get_selection().clear()
	EditorInterface.get_selection().add_node(w)
	
	
	
