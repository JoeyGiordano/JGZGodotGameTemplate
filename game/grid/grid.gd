@tool
extends Node
class_name Grid

## Provides resource methods for translating between real and grid coordinates.
## The grid is made up of points, edges, and squares.
## The grid point (0,0) is at the bottom left of grid square (0,0). Edges are defined by two grid points.
## When there is no offest, the grid point (0,0) is at real coordinates (0,0) and the center of grid square (0,0) is at real coordinates (scale_/2,scale_/2)
## More generally, the grid point (a,b) is at real coordinates (a*size+offset, b*size+offset)

## Width of each grid square in pixels
@export var scale_ : float = 40
## Offset of the grid origin from the real coordinate origin in pixels
@export var offset : Vector2 = Vector2(0,0)

enum COORD_TYPE {
	GRID,
	REAL
}

# Basic getters

## Translates a grid coordinate to a real coordinate (no rounding)
func grid_to_real(grid_coord : Vector2) -> Vector2 :
	return grid_coord * scale_ + offset

## Translates a real coordinate to a grid coordinate (no rounding)
func real_to_grid(real_coord : Vector2) -> Vector2 :
	return (real_coord - offset) / scale_

#Nearest

func nearest_point(point : Vector2, input_coord_type : COORD_TYPE , output_coord_type : COORD_TYPE) -> Vector2 :
	#ensure point is in grid coords
	if input_coord_type == COORD_TYPE.REAL :
		point = real_to_grid(point)
	
	#round to nearest point
	point = round(point)
	
	#return the output in the correct coordinate system
	if output_coord_type == COORD_TYPE.REAL : 
		return grid_to_real(point)
	else : return point

func nearest_square_center(point : Vector2, input_coord_type : COORD_TYPE , output_coord_type : COORD_TYPE)  -> Vector2 :
	#ensure point is in grid coords
	if input_coord_type == COORD_TYPE.REAL :
		point = real_to_grid(point)
	
	#round to nearest square center
	point = round(point - Vector2(0.5,0.5)) + Vector2(0.5,0.5)
	
	#return the output in the correct coordinate system
	if output_coord_type == COORD_TYPE.REAL : 
		return grid_to_real(point)
	else : return point

func nearest_horizontal_edge_center(point : Vector2, input_coord_type : COORD_TYPE , output_coord_type : COORD_TYPE)  -> Vector2 :
	#ensure point is in grid coords
	if input_coord_type == COORD_TYPE.REAL :
		point = real_to_grid(point)
	
	#round to nearest edge center
	point = round(point - Vector2(0.5,0)) + Vector2(0.5,0)
	
	#return the output in the correct coordinate system
	if output_coord_type == COORD_TYPE.REAL : 
		return grid_to_real(point)
	else : return point

func nearest_vertical_edge_center(point : Vector2, input_coord_type : COORD_TYPE , output_coord_type : COORD_TYPE)  -> Vector2 :
	#ensure point is in grid coords
	if input_coord_type == COORD_TYPE.REAL :
		point = real_to_grid(point)
	
	#round to nearest edge center
	point = round(point - Vector2(0,0.5)) + Vector2(0,0.5)
	
	#return the output in the correct coordinate system
	if output_coord_type == COORD_TYPE.REAL : 
		return grid_to_real(point)
	else : return point

func nearest_edge_center(point : Vector2, input_coord_type : COORD_TYPE , output_coord_type : COORD_TYPE)  -> Vector2 :
	#ensure point is in grid coords
	if input_coord_type == COORD_TYPE.REAL :
		point = real_to_grid(point)
	
	#round to nearest edge center
	var v_point = round(point - Vector2(0,0.5)) + Vector2(0,0.5)
	var h_point = round(point - Vector2(0.5,0)) + Vector2(0.5,0)
	if point.distance_to(v_point) < point.distance_to(h_point) :
		point = v_point
	else :
		point = h_point
	
	#return the output in the correct coordinate system
	if output_coord_type == COORD_TYPE.REAL : 
		return grid_to_real(point)
	else : return point
