extends Node2D
class_name Enemy

@onready var sprite : Sprite2D = $Sprite2D

@export var state : int = 0 #0 red, 1 green, 2 blue

func _enter_tree():
	set_multiplayer_authority(1)

func _ready():
	$Area2D.area_entered.connect(_on_area_entered)

func _process(delta):
	update_color()
	
	if !is_multiplayer_authority() : return
	rotation += -7 * delta
	position -= (position - Vector2(550,300)) * delta * 0.8


func _on_area_entered(area : Area2D) :
	if !is_multiplayer_authority() : return
	
	if area.get_parent() is Player : return #if we fought a player, the player will handle it
	
	var result = Player.resolve_interaction(state, area.get_parent().state)
	if result == "Uwin" : #if we won, the other one will kill itself
		die()

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
