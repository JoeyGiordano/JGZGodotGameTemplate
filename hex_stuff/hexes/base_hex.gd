extends Node2D
class_name BaseHex

## BaseHex is a template for other hexes (all other hexes should extend this class).
## Override these methods to give other types of hexes different behavior.

## A unique id set by the 
var debug_id

## The coordinates of the spot on the map that this hex holds. The hex may not necessarily be at the associated real position.
var grid_coords : Vector2i


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

#region Private Resource Functions
## Don't touch or override these methods.

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

#endregion
