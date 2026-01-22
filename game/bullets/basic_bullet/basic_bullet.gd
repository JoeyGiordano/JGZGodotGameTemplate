extends RigidBody2D
class_name BasicBullet

@onready var hitbox : Area2D = $Hitbox

var source_tank_id : int = -1
var source_tank_invincible : bool = true #this will get turned off 0.1 seconds after the bullet is shot, prevents tanks from accidentally shooting themselves unless they are going way faster than their own bullets
var dir_changed : bool = false #set to true the first time the bullet bounces

var speed : float
var dir : Vector2
var lifetime : float #lifetime in seconds

func _ready() :
	GameManager.end_of_round.connect(on_end_of_round)
	hitbox.area_entered.connect(on_area_entered)
	body_entered.connect(on_body_entered)
	
	linear_velocity = speed * dir.normalized()
	
	#source tank invincibility
	await get_tree().create_timer(0.07).timeout
	source_tank_invincible = false

func _process(delta):
	lifetime -= delta
	if lifetime <= 0 :
		#play bullet disappread sound and anim
		queue_free()

## Signal Response

func on_area_entered(area : Area2D) : #contact_monitor must be set to true and max_contacts_reported must be >0
	if area.is_in_group("tank_hitbox") :
		var tank : Tank = area.get_parent().tank_rigidbody.tank #all tank hitboxes must be direct children of a tank loadout
		if tank.id == source_tank_id && source_tank_invincible && !dir_changed :
			return #a tank can't hit itself with its own bullet for a brief moment after the bullet has been shot, unless the bullet has bounced off a wall during that moment
		tank.die()
		queue_free()

func on_body_entered(_body : Node) :
	dir_changed = true

func on_end_of_round() :
	queue_free()

## Misc

static func instantiate(position_ : Vector2 , speed_ : float, dir_ : Vector2, lifetime_ : float) -> BasicBullet :
	#create a new bullet and return it
	#instantiate a tank from the .tscn
	var b : BasicBullet = Ref.basic_bullet.instantiate() #have to call to game container here bc this method is static
	
	#set the variables
	b.speed = speed_
	b.dir = dir_
	b.position = position_
	b.lifetime = lifetime_
	
	#add the new bullet to the scene tree in the correct placem
	Global.Entities.add_child(b)
	return b
	
	
