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

## Create/move/remove types (allows for different animations on create move and remove)
enum CREATE_TYPE {
	INSTANT,FADE_IN
}
enum MOVE_TYPE {
	INSTANT,SLIDE
}
enum REMOVE_TYPE {
	INSTANT,FADE_OUT
}

## A unique id set by the HexManager when the hex is created
var debug_id

## The coordinates of the spot on the map that this hex holds. The hex may not necessarily be at the associated real position.
var grid_coords : Vector2i

## This function is automatically called every HexManager.tick_duration seconds.
## We could break tick into more calls in HexManager (eg generate_resources(), resolve_damage(), act_on_neighbors()) for more consistent behavior.
func tick() :
	pass

## This function is automatically called when the hex is created and added to the map.
func on_added_to_map(_type: CREATE_TYPE) :
	#on_added_debug()
	#could add other animations here (or in overriden version)
	match _type :
		CREATE_TYPE.INSTANT :
			position = real_pos()
		CREATE_TYPE.FADE_IN :
			modulate.a = 0
			position = real_pos()
			#fade in
			var tween = create_tween()
			tween.tween_property(self, "modulate:a", 1, 0.8)

func on_added_debug() :
	$Label.text = str(debug_id)
	#$Label.text = str(grid_coords)
	#$Label.text = str(HexManager.grid.axial_to_cube(grid_coords))

## This function is automatically called when the hex is moved from one grid spot to another.
func on_moved(_type: MOVE_TYPE) :
	#could add other animations here (or in overriden version)
	match _type :
		MOVE_TYPE.INSTANT :
			position = real_pos()
		MOVE_TYPE.SLIDE :
			var tween = create_tween()
			tween.tween_property(self, "position", real_pos(), 0.8)

## This function is automatically called when the hex is about to be removed from the map and queue_freed.
## Although this hex will not hold the grid spot anymore, the hex's nodes can stay in the same real position to do disappear animations etc.
func on_removed_from_map(_type: REMOVE_TYPE) :
	#could add other animations here (or in overriden version)
	#don't forget to queue free it tho
	match _type :
		REMOVE_TYPE.INSTANT :
			queue_free()
		REMOVE_TYPE.FADE_OUT :
			var tween = create_tween()
			tween.tween_property(self, "modulate:a", 0, 0.8)
			queue_free()

#region Utils
## Don't touch or override these functions.

## Do not override.
func move(new_grid_coords: Vector2i, type: MOVE_TYPE = MOVE_TYPE.INSTANT) :
	HexManager.move_hex(self,new_grid_coords,type)

func move_(new_x: int, new_y: int, type: MOVE_TYPE = MOVE_TYPE.INSTANT) :
	move(Vector2i(new_x,new_y),type)

## Do not override.
func remove_from_map(type: REMOVE_TYPE = REMOVE_TYPE.INSTANT) :
	HexManager.remove_hex(self,type)

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

## Do not override.
func get_adjacent_coords() -> Array[Vector2i]:
	return HexManager.get_adjacent_coords(grid_coords)

## Do not override.
func get_adjacent_hexes() -> Array[BaseHex]:
	return HexManager.get_adjacent_hexes(grid_coords)

## Do not override. Returns true if target_grid_coords are up to or including n spaces away.
func is_within(target_grid_coords: Vector2i, n:int) -> bool:
	return nearest_neighbor_dist(target_grid_coords) <= n

## Do not override.
func is_hex_within(target_hex:BaseHex, n:int) -> bool:
	return is_within(target_hex.grid_coords,n)

## Do not override. Returns what level of nearest neighbor the grid coords are (an adjacent tile returns 1).
func nearest_neighbor_dist(target_grid_coords: Vector2i) -> int:
	return HexManager.nearest_neighbor_dist(grid_coords, target_grid_coords)

## Do not override.
func nearest_neighbor_dist_(target_hex: BaseHex) -> int:
	return nearest_neighbor_dist(target_hex.grid_coords)

## Do not override.
func corner_pos(corner: HexGrid.CORNER) -> Vector2:
	return HexManager.get_corner_pos(grid_coords, corner)

## Do not override.
func edge_midpoint(edge: HexGrid.EDGE) -> Vector2:
	return HexManager.get_edge_midpoint(grid_coords, edge)

#endregion
