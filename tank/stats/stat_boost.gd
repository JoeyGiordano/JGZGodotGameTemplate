extends Resource
class_name StatBoost

### StatBoost ###
## A resource that holds all of the stats for a tank.
## It also has some helper functions used by stats handler
## NOTE when adding a new stat, you must also add a line in all of the resource functions (add, subtract, copy) IMPORTANT

## Stats
#Movement 
@export var forward_speed : float
#@export var forward_speed_multiplier : float
@export var backward_speed : float
@export var rotation_speed : float #split into left and right?
@export var linear_damp_factor : float
@export var angular_damp_factor : float

#Bullet
@export var bullet_count : int
@export var bullet_lifetime : float  # in seconds
@export var bullet_speed : float  #in pixels/second

## Boost Functions
@export var func_names : Array[String]

## Resource functions
func add(s : StatBoost) :
	# we can possibly use logrithmic adding if we want things to stay above zero (or just use min)
	forward_speed += s.forward_speed
	backward_speed += s.backward_speed
	rotation_speed += s.rotation_speed
	linear_damp_factor += s.linear_damp_factor
	angular_damp_factor += s.angular_damp_factor
	bullet_count += s.bullet_count
	bullet_lifetime += s.bullet_lifetime
	bullet_speed += s.bullet_speed

func subtract(s : StatBoost) :
	forward_speed -= s.forward_speed
	backward_speed -= s.backward_speed
	rotation_speed -= s.rotation_speed
	linear_damp_factor -= s.linear_damp_factor
	angular_damp_factor -= s.angular_damp_factor
	bullet_count -= s.bullet_count
	bullet_lifetime -= s.bullet_lifetime
	bullet_speed -= s.bullet_speed

func copy() -> StatBoost :
	var s = StatBoost.new()
	s.func_names = func_names
	s.forward_speed = forward_speed
	s.backward_speed = backward_speed
	s.rotation_speed = rotation_speed
	s.linear_damp_factor = linear_damp_factor
	s.angular_damp_factor = angular_damp_factor
	s.bullet_count = bullet_count
	s.bullet_lifetime = bullet_lifetime
	s.bullet_speed = bullet_speed
	return s

func as_string() -> String :
	var s = ""
	s = s + "Forward Speed: " + str(forward_speed) + "\n"
	s = s + "Backward Speed: " + str(backward_speed) + "\n"
	s = s + "Rotation Speed: " + str(rotation_speed) + "\n"
	s = s + "Linear Damp Factor: " + str(linear_damp_factor) + "\n"
	s = s + "Angular Damp Speed: " + str(angular_damp_factor) + "\n"
	s = s + "Bullet Count: " + str(bullet_count) + "\n"
	s = s + "Bullet Lifetime: " + str(bullet_lifetime) + "\n"
	s = s + "Bullet Speed: " + str(bullet_speed) + "\n"
	return s
