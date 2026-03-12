extends Node2D

# terminology
# a torus is formed by drawing a circle and a line in the same 2d plane, then revolving the circle around the line to create a surface/volume in 3d.
# axis of rotation - the line in the above description
# circle of revolution - the circle in the above description
# torodial direction - long way around, encircling the central void
# poloidal direction - short way around, through the hole
# theta - torodial angle, increasing counterclockwise, arbitrary starting point, [-180,180]
# phi - polodial angle, starting from the outside diameter of the torus, increasing up, [-180,180]
# top down cross section - the cross section that creates concentric circles (looks down the axis of rotation) and divides the torus in half
# perpendicular cross section - a cross section that shows two circle of revolution and divides the torus in half
# centerline - the circle formed by revolving the center of the circle of revolution around the axis of rotation, ie the centerline of the tube
# centerpoint - the point on the axis of revolution closest to center of the circle of revolution
# R - torodial (big) radius, distance from the centerpoint to the centerline
# r - polodial (small) radius, distance from the centerline to the surface of the torus

## Big radius
const R : float = 45
## Small radius
const r : float = 20
## Radius Ratio - measure of torus dimension (ring torus : b>1, horn torus: b=1, spindle torus b<1)
const b : float = R/r

# the projection
# the outermost (torodial) diameter is the x axis (y=0) and the y axis (x=0) is some arbitrary polodial diameter
# the projection wraps in both x and y (ie y=pi*r is the same as y=-pi*r and similar for x and R)
# ds² = (R+rcos(ϕ))²dθ² + r²dϕ²
# this gives dy=r*dϕ and dx=(R+rcos(ϕ))*dθ, or dϕ=dy/r and dθ=dx/(R+rcos(ϕ))
# instead of doing it frame by frame, it'll be more accurate to integrate
# integrating dϕ is independent of path, but integrating dθ is path dependent

# current position
var theta : float = 0 ## RADIANS, between -PI and PI
var phi : float = 0 ## RADIANS, between -PI and PI


# assume a straight line path, ie for the entirety of Δx and Δy, dy=m*dx
const prefactor_A = 2/sqrt(pow(b,2) - 1)
const prefactor_B = sqrt(b-1)/sqrt(b+1)
func update_thetaphi_from_straightline_delta_xy(delta_x: float, delta_y: float) :
	var new_phi
	var new_theta
	var delta_phi
	var delta_theta
	#calculate delta phi
	delta_phi = delta_y/r
	new_phi = phi + delta_phi
	#calculate delta theta
	if delta_x == 0 :
		delta_theta = 0
	else :
		if delta_y == 0 :
			#if delta_y is 0, there is no pos change in the polodial direction, its all in the torodial direction
			#so it can be calculated with (also inverse_slope would be infinite)
			delta_theta = delta_x/(R+r*cos(phi))
		else : #delta_y is non_zero, use the straighline integral way
			var inverse_slope = delta_x/delta_y
			delta_theta = inverse_slope * prefactor_A * ( atan(prefactor_B*tan(new_phi/2)) - atan(prefactor_B*tan(phi/2)) )
			# account for atan not being the continuous and new_phi might be more than pi so we'd be integrating over the discontinuity(ies)
			# no need to make the adjustment for old phi since it should always be wrapped -PI to PI
			delta_theta += inverse_slope * PI * ( roundf(new_phi/(2*PI)) )#- roundf(phi/(2*PI)) )
	new_theta = theta + delta_theta
	
	phi = wrapf(new_phi,-PI,PI)
	theta = wrapf(new_theta,-PI,PI)
	
## Test 1
func _ready() -> void:
	#game_loop()
	pass

@onready var label :Label= get_parent().get_node("Label")
@onready var label2 :Label= get_parent().get_node("Label2")
@onready var phi_bar = get_parent().get_node("Phi")
@onready var theta_bar = get_parent().get_node("Theta")
@onready var marker = preload("uid://bonvosm05kh5")
func game_loop1() :
	#await get_tree().create_timer(0.1).timeout
	theta = 0
	phi = PI/2
	update_thetaphi_from_straightline_delta_xy(position.x, position.y)
	update_display()

func update_display() :
	phi_bar.value = rad_to_deg(phi)
	theta_bar.value = rad_to_deg(theta)
	
	label.text = str(snapped(position, Vector2(0.1,0.1))) + " " + str(snapped(rad_to_deg(theta),0.1)) + " " + str(snapped(rad_to_deg(phi),0.1))

var prev_pos
func game_loop2() :
	var dpos = position - prev_pos
	label2.text = str(dpos)
	update_thetaphi_from_straightline_delta_xy(dpos.x, dpos.y)
	update_display()
	

var speed = 100
func _process(delta: float) -> void:
	prev_pos = position
	position += speed * delta * Vector2(Input.get_axis("left","right"), Input.get_axis("up","down"))
	#game_loop1()
	game_loop2()
