extends Object
class_name HexGrid

# see res://hex_stuff/HexGridGuide.png ("uid://dy7h6t3p2n6j")

const sqrt3 : float = sqrt(3)

var a : float # side length or long radius (d/2) (circumradius)
var d : float # long diameter (2a) (circumdiameter)
var s : float # short diameter (2r) (indiameter)
var r : float # short radius (s/2) (inradius)
var vscale : float = 1 # vertical scale, use to squish and stretch grid to get perspective effect
var rotation : float = 0 # in degrees (0 to 360)

var x_basis_vec : Vector2
var y_basis_vec : Vector2

func _init(_a : float) -> void:
	set_a(_a)

func update_basis() :
	# set the basis vectors given the hex grid params
	x_basis_vec = Vector2(1.5*a, -r)
	y_basis_vec = Vector2(0,-s)
	# apply rotation
	if rotation != 0 :
		push_warning("Caution: Using a rotated grid may confuse HexGrid direction terminolgy.")
		x_basis_vec = x_basis_vec.rotated(deg_to_rad(rotation))
		y_basis_vec = y_basis_vec.rotated(deg_to_rad(rotation))
	# apply vert squish or stretch
	x_basis_vec = Vector2(x_basis_vec.x, vscale*x_basis_vec.y)
	y_basis_vec = Vector2(y_basis_vec.x, vscale*y_basis_vec.y)

#region Grid <--> Real Conversion
# because of funky hexagon grid stuff, this only provides functions to go from grid points to real and back.
# general grid space conversions (ie float inputs for grid_to_real and Vector2 outputs for the real_to_grid)
#  are possible, but becaues the basis of a hexagonal grid is not orthonormal, it would result in behavior that
#  would seem unexpected to someone that doesn't understand basis transformations and whatnot.

func grid_to_realv(grid_coords : Vector2) -> Vector2 :
	return grid_to_real(grid_coords.x, grid_coords.y)

func grid_to_real(grid_x_coord : float, grid_y_coord : float) -> Vector2 :
	return x_basis_vec*grid_x_coord + y_basis_vec*grid_y_coord

func real_to_grid_nearest(real_x_coord : float, real_y_coord : float) -> Vector2i :
	return real_to_grid_nearestv(Vector2(real_x_coord, real_y_coord))

func real_to_grid_nearestv(real_coords : Vector2) -> Vector2i :
	# you can't just round the real_to_grid() because the hexagonal grid is not orthonormal
	# first we have to undo the scale and rotate transformations so we can use the HexGridGuide.png diagram
	# undo the vert squish or stretch
	real_coords = Vector2(real_coords.x, real_coords.y/vscale)
	# unrotate the real space point
	real_coords = real_coords.rotated(deg_to_rad(-rotation))
	# now that we have the untransformed real space point we can get the nearest grid point using cube fraction coords
	# ---- world -> fractional axial ----
	var _q = (2.0/3.0 * real_coords.x) / a
	var _r = (-1.0/3.0 * real_coords.x + sqrt3/3.0 * real_coords.y) / a

	# ---- axial -> cube (fractional) ----
	var _x = _q
	var _z = _r
	var _y = -_x - _z

	# ---- cube rounding ----
	var rx = round(_x)
	var ry = round(_y)
	var rz = round(_z)

	var dx = abs(rx - _x)
	var dy = abs(ry - _y)
	var dz = abs(rz - _z)

	if dx > dy and dx > dz:
		rx = -ry - rz
	elif dy > dz:
		ry = -rx - rz
	else:
		rz = -rx - ry

	var cube = Vector3i(int(rx), int(ry), int(rz))

	# ---- cube -> 2D hex coords ----
	var hex_2d = Vector2i(cube.x, cube.y)

	return hex_2d

func axial_to_cube(axial: Vector2i) -> Vector3i :
	return Vector3i(axial.x,axial.y,-axial.x-axial.y)

func axial_to_cube_(axial_x:int, axial_y:int) -> Vector3i :
	return axial_to_cube(Vector2i(axial_x,axial_y))

#endregion

#region Setters

func set_a(new_a : float) :
	a = new_a
	d = 2*new_a
	r = new_a * sqrt3 / 2
	s = 2*r
	update_basis()

func set_d(new_d : float) :
	set_a(new_d/2)

func set_s(new_s : float) :
	set_a(new_s/sqrt3)

func set_r(new_r : float) :
	set_a(new_r*2/sqrt3)

func set_rotation(new_rotation_degrees : float) :
	rotation = new_rotation_degrees
	update_basis()

func set_vscale(new_vscale : float) :
	vscale = new_vscale
	update_basis()

#endregion
