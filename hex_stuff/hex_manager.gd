extends Node

### AUTOLOAD

### HexManager ###
##

var base_hex : PackedScene = preload("res://hex_stuff/hexes/base_hex.tscn")

## The grid that 
var grid = HexGrid.new(40)

## An array of all hexes on the map for easy iteration (as opposed to having to do difficult iteration through the map double dictionary).
var hex_list : Array[BaseHex] = []
## Stores the hexes based on their grid coordinates for easy access by coords.
var map : DoubleDict = DoubleDict.new()

# Other
var next_debug_id = 0

enum DIRECTIONS {
	N,NE,SE,S,SW,NW
}

#region access

## Returns true if there is a hex at grid_coords.
func is_hex_at(grid_coords: Vector2i) -> bool:
	return map.has_entryv(grid_coords)

## Gets the hex at grid_coords.
func get_hex(grid_coords: Vector2i) -> BaseHex:
	return map.get_entryv(grid_coords)

## Like get_hex() but uses relative_to_hex as the origin.
func get_hex_relative(relative_to_hex: BaseHex, relative_grid_coords: Vector2i) -> BaseHex:
	return get_hex(relative_to_hex.grid_coords + relative_grid_coords)

## Like get_hex() but uses relative_to_coords as the origin.
func get_hex_relative_to(relative_to_coords: Vector2i, relative_grid_coords: Vector2i) -> BaseHex:
	return get_hex(relative_to_coords + relative_grid_coords)

## Returns the real position associated with grid_coords.
func get_associated_real_position(grid_coords: Vector2i) -> Vector2:
	return grid.grid_to_realv(grid_coords)

#TODO directional stuff (maybe in base hex)

#region modify

## Creates a hex grid_coords. If there is already there, throws an error. 
func create_hex(grid_coords: Vector2i):
	if map.has_entryv(grid_coords) :
		push_error("Tried to create a new hex at " + str(grid_coords) + " but a hex was already there.")
		return
	# instantiate
	#TODO type options
	var hex : BaseHex = base_hex.instantiate()
	# set parent
	if Global.IS_RUNNING_FROM_GAME_CONTAINER :
		Global.Hexes.add_child(hex)
	else :
		get_tree().root.add_child(hex)
	# set debug id
	hex.debug_id = next_debug_id
	next_debug_id += 1
	# register
	_register_hex_at(hex, grid_coords)
	# call on_added_to_map for unique behavior
	hex.on_added_to_map()

#TODO type options
## Moves a hex from its current position to new_grid_coords.
func move_hex(hex: BaseHex, new_grid_coords: Vector2i):
	if map.has_entryv(new_grid_coords) :
		push_error("Tried to move a hex to " + str(new_grid_coords) + " but a hex was already there.")
		return
	_set_hex_position(hex, new_grid_coords)
	hex.on_moved()

## Moves the hex at old_grid_coords to new_grid_coords.
func move_hex_from(old_grid_coords: Vector2i, new_grid_coords: Vector2i):
	if map.has_entryv(old_grid_coords) :
		push_error("Tried to move a hex from " + str(new_grid_coords) + " but there was no hex there.")
		return
	move_hex(get_hex(old_grid_coords),new_grid_coords)

## Removes and deletes the hex.
func remove_hex(hex: BaseHex):
	_unregister_hex(hex)
	hex.on_removed_from_map()

#region private

## INTERNAL USE ONLY. You might be looking for create_hex().
## Adds a new hex to hex_list and map and sets its position.
func _register_hex_at(hex: BaseHex, grid_coords: Vector2i):
	hex_list.append(hex)
	_set_hex_position(hex, grid_coords)

## INTERNAL USE ONLY. You might be looking for move_hex(). 
## Directly sets the hexes position. Overrides any existing hex.
func _set_hex_position(hex: BaseHex, grid_coords: Vector2i):
	hex.grid_coords = grid_coords
	map.set_entryv(grid_coords,hex)

## INTERNAL USE ONLY. You might be looking for remove_hex().
## Removes a hex from hex_list and map.
func _unregister_hex(hex: BaseHex):
	hex_list.erase(hex)
	map.delete_entryv(hex.grid_coords)
