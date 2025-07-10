extends Node2D
class_name Enemy

@onready var sprite : Sprite2D = $Sprite2D

@export var state : int = 0 #0 red, 1 green, 2 blue

func _enter_tree():
	set_multiplayer_authority(1)

func _process(delta):
	update_color()
	
	if !is_multiplayer_authority() : return
	rotation += -7 * delta
	position -= (position - Vector2(550,300)) * delta * 0.8

func die() :
	rpc("_die")

@rpc("any_peer", "call_local")
func _die() :
	sprite.modulate = Color.BLACK
	state = 3 #so no death
	await get_tree().create_timer(0.3).timeout
	queue_free()

func update_color() :
	match(state) :
		0 : sprite.modulate = Color.RED
		1 : sprite.modulate = Color.GREEN
		2 : sprite.modulate = Color.BLUE
