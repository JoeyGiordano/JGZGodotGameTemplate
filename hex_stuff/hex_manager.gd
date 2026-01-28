extends Node

### AUTOLOAD

### HexManager ###
## Manages the hexes and the hex map.

## Directions (using Vector2 instead of enum so you can add with them, also declared in BaseHex for easy access)
const NW = Vector2(-1,1)
const NORTH = Vector2(0,1)
const NE = Vector2(0,1)
const SE = Vector2(1,-1)
const SOUTH = Vector2(0,-1)
const SW = Vector2(-1,0)

## Allows conversion between real and grid coordinates.
var grid = HexGrid.new(20)

## An array of all hexes on the map for easy iteration (as opposed to having to do difficult iteration through the map double dictionary).
var hex_list : Array[BaseHex] = []
## Stores the hexes based on their grid coordinates for easy access by coords.
var map : DoubleDict = DoubleDict.new()

## Tick timing
const tick_duration : float = 0.1 #in seconds
var time_since_last_tick : float = 0

# Other
var next_debug_id = 0
var base_hex : PackedScene = preload("res://hex_stuff/base_hex.tscn")

func _physics_process(_delta: float) -> void:
	manage_tick(_delta)

func manage_tick(_delta: float) :
	time_since_last_tick += _delta
	if time_since_last_tick > tick_duration :
		time_since_last_tick -= tick_duration
		tick()

## We could break tick into more calls (eg generate_resources(), resolve_damage(), act_on_neighbors()) for more consistent behavior.
func tick() :
	for hex in hex_list :
		hex.tick()

#region access

## Returns true if there is a hex at grid_coords.
func is_hex_at(grid_coords: Vector2i) -> bool:
	return map.has_entryv(grid_coords)

## See is_hex_at().
func is_hex_at_(x:int,y:int) -> bool:
	return is_hex_at(Vector2i(x,y))

## Gets the hex at grid_coords.
func get_hex(grid_coords: Vector2i) -> BaseHex:
	return map.get_entryv(grid_coords)

## See get_hex().
func get_hex_(x:int,y:int) -> BaseHex:
	return get_hex(Vector2i(x,y))

## Like get_hex() but uses relative_to_hex as the origin.
func get_hex_relative(relative_to_hex: BaseHex, relative_grid_coords: Vector2i) -> BaseHex:
	return get_hex(relative_to_hex.grid_coords + relative_grid_coords)

## Like get_hex() but uses relative_to_coords as the origin.
func get_hex_relative_to(relative_to_coords: Vector2i, relative_grid_coords: Vector2i) -> BaseHex:
	return get_hex(relative_to_coords + relative_grid_coords)

## Returns the real position associated with grid_coords.
func get_associated_real_position(grid_coords: Vector2) -> Vector2:
	return grid.grid_to_realv(grid_coords)

#endregion

#region modify

## Creates a hex grid_coords. If there is already there, throws an error. 
func create_hex(grid_coords: Vector2i) -> BaseHex:
	if map.has_entryv(grid_coords) :
		push_error("Tried to create a new hex at " + str(grid_coords) + " but a hex was already there.")
		return
	# instantiate
	#TODO type options
	var hex : BaseHex = base_hex.instantiate()
	# set parent
	add_child(hex)
	# set debug id
	hex.debug_id = next_debug_id
	next_debug_id += 1
	# register
	_register_hex_at(hex, grid_coords)
	# call on_added_to_map for unique behavior
	hex.on_added_to_map()
	return hex

## See create_hex().
func create_hex_(x:int,y:int) -> BaseHex:
	return create_hex(Vector2i(x,y))

#TODO type options
## Moves a hex from its current position to new_grid_coords.
func move_hex(hex: BaseHex, new_grid_coords: Vector2i):
	if map.has_entryv(new_grid_coords) :
		push_error("Tried to move a hex to " + str(new_grid_coords) + " but a hex was already there.")
		return
	_set_hex_position(hex, new_grid_coords)
	hex.on_moved()

## See move_hex().
func move_hex_(hex: BaseHex, new_x: int, new_y: int) :
	move_hex(hex,Vector2i(new_x,new_y))

## Moves the hex at old_grid_coords to new_grid_coords.
func move_hex_from(old_grid_coords: Vector2i, new_grid_coords: Vector2i):
	if map.has_entryv(old_grid_coords) :
		push_error("Tried to move a hex from " + str(new_grid_coords) + " but there was no hex there.")
		return
	move_hex(get_hex(old_grid_coords),new_grid_coords)

## See move_hex_from().
func move_hex_from_(old_x:int,old_y:int,new_x:int,new_y:int):
	move_hex_from(Vector2i(old_x,old_y),Vector2i(new_x,new_y))

## Removes and deletes the hex.
func remove_hex(hex: BaseHex):
	_unregister_hex(hex)
	hex.on_removed_from_map()

#endregion

#region advanced getters

## Returns a list of coords of all of the grid points that are within a hexagon of radius radius around center.
## ie if radius = 3, this returns the first, second, and third nearest neighbors to center (optionally excluding center)
## Ordered from bottom left to top right
func get_coords_in_hexagon(radius: int, center: Vector2i = Vector2i.ZERO, exclude_center: bool = false) -> Array[Vector2i]:
	var a : Array[Vector2i] = []
	for i in range(-radius, radius+1) :
		for j in range(-radius, radius+1) :
			if abs(i+j)>radius: # use this condition to get hexagon shape
				continue #skip this cycle of the for loop
			if i == 0 and j == 0 and exclude_center :
				continue
			a.append(Vector2i(center.x+i,center.y+j))
	return a

## Exactly like get_coords_in_hexagon() except returns a list of all hexes in those grid spots.
func get_hexes_in_hexagon(radius: int, center: Vector2i = Vector2i.ZERO, exclude_center: bool = false) -> Array[BaseHex] :
	var a : Array[BaseHex] = []
	for i in range(-radius, radius+1) :
		for j in range(-radius, radius+1) :
			if abs(i+j)>radius: # use this condition to get hexagon shape
				continue #skip this cycle of the for loop
			if exclude_center and i == 0 and j == 0 :
				continue
			if !is_hex_at_(center.x+i,center.y+j) :
				continue
			a.append(get_hex_(i,j))
	return a 

## Returns the grid coordinates of all nth nearest neighbors to center, ie the ring of hexes n hexes away from center.
func get_nth_nearest_neighbor_coords(n: int, center: Vector2i = Vector2i.ZERO) -> Array[Vector2i]:
	var a : Array[Vector2i] = []
	for i in range(-n, n+1) :
		for j in range(-n, n+1) :
			if abs(i+j)==n: # use this condition to get hexagon shape
				continue #skip this cycle of the for loop
			a.append(Vector2i(center.x+i,center.y+j))
	return a

## Exactly like get_nth_nearest_neighbor_coords() except returns a list of all hexes in those grid spots.
func get_nth_nearest_neighbor_hexes(n: int, center: Vector2i = Vector2i.ZERO) -> Array[BaseHex]:
	var a : Array[BaseHex] = []
	for i in range(-n, n+1) :
		for j in range(-n, n+1) :
			if abs(i+j)==n: # use this condition to get hexagon shape
				continue #skip this cycle of the for loop
			if !is_hex_at_(center.x+i,center.y+j) :
				continue
			a.append(get_hex_(center.x+i,center.y+j))
	return a

## NOTE: HexManager does not provide a function to filter arrays of BaseHex on a condition, instead use Array.filter()

## TODO
func get_contiguous():
	pass

#endregion

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

#endregion
