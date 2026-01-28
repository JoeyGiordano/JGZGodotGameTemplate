extends Node2D
class_name BaseHex

## BaseHex is a template for other hexes (all other hexes should extend this class).
## Override these methods to give other types of hexes different behavior.

## Directions (using Vector2 instead of enum so you can add with them, also declared in HexManager for easy access)
const NW = Vector2(-1,1)
const NORTH = Vector2(0,1)
const NE = Vector2(0,1)
const SE = Vector2(1,-1)
const SOUTH = Vector2(0,-1)
const SW = Vector2(-1,0)

## A unique id set by the HexManager when the hex is created
var debug_id

## The coordinates of the spot on the map that this hex holds. The hex may not necessarily be at the associated real position.
var grid_coords : Vector2i

## This function is automatically called every HexManager.tick_duration seconds.
## We could break tick into more calls in HexManager (eg generate_resources(), resolve_damage(), act_on_neighbors()) for more consistent behavior.
func tick() :
	pass

## This function is automatically called when the hex is created and added to the map.
func on_added_to_map() :
	position = real_pos() #could instead add some animation here (or in overriden version)

## This function is automatically called when the hex is moved from one grid spot to another.
func on_moved() :
	position = real_pos() #could instead add some animation here (or in overriden version)

## This function is automatically called when the hex is about to be removed from the map and queue_freed.
## Although this hex will not hold the grid spot anymore, the hex's nodes can stay in the same real position to do disappear animations etc.
func on_removed_from_map() :
	queue_free() #could instead add some animation here (or in overriden version)
	#don't forget to queue free it tho

#region Utils
## Don't touch or override these functions.

## Do not override.
func move(new_grid_coords: Vector2i) :
	HexManager.move_hex(self,new_grid_coords)

func move_(x:int,y:int) :
	move(Vector2i(x,y))

## Do not override.
func remove_from_map() :
	HexManager.remove_hex(self)

## Do not override.
func real_pos() -> Vector2:
	return HexManager.get_associated_real_position(grid_coords)

## Do not override. Gets the hex at the grid spot self.grid_coords + relative_grid_coords.
func get_hex_rel(relative_grid_coords: Vector2i) -> BaseHex:
	return HexManager.get_hex_relative_to(grid_coords, relative_grid_coords)

## Do not override.
func get_coords_within(radius:int) -> Array[Vector2i]:
	return HexManager.get_coords_in_hexagon(radius,grid_coords)

## Do not override.
func get_hexes_within(radius:int) -> Array[BaseHex]:
	return HexManager.get_hexes_in_hexagon(radius,grid_coords)

## Do not override.
func nth_nearest_neighbors_coords(n:int) -> Array[Vector2i]:
	return HexManager.get_nth_nearest_neighbors_coords(n,grid_coords)

## Do not override.
func nth_nearest_neighbors(n:int) -> Array[BaseHex]:
	return HexManager.get_nth_nearest_neighbors_hexes(n,grid_coords)

## Do not override. Returns true if target_grid_coords are up to or including n spaces away.
func is_within(target_grid_coords: Vector2i, n:int) -> bool:
	return nearest_neighbor_dist(target_grid_coords) <= n

## Do not override.
func is_hex_within(target_hex:BaseHex, n:int) -> bool:
	return is_within(target_hex.grid_coords,n)

## Do not override. Returns what level of nearest neighbor the grid coords are (an adjacent tile returns 1).
func nearest_neighbor_dist(target_grid_coords: Vector2i) -> int:
	var rel = target_grid_coords - grid_coords
	return abs(rel.x+rel.y)

## Do not override.
func nearest_neighbor_dist_(target_hex: BaseHex) -> int:
	return nearest_neighbor_dist(target_hex.grid_coords)

#endregion
