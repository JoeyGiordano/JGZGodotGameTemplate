extends Node2D
class_name Enemy

@onready var sprite : Sprite2D = $Sprite2D

@export var state : int = 0 #0 red, 1 green, 2 blue

var behaviors : Array[String]

var behavior_frame : int = 0

func _enter_tree():
	set_multiplayer_authority(1)

func _ready():
	$Area2D.area_entered.connect(_on_area_entered)
	behavior_loop()

func _process(delta):
	update_color()
	
	if !is_multiplayer_authority() : return
	
	behavior_frame += 1
	
	for b : String in behaviors :
		call(b, delta)

func behavior_loop() :
	behavior_frame = 0
	clear_behaviors()
	randomize_behaviors()
	await get_tree().create_timer(randf_range(4,15)).timeout
	behavior_loop()

func randomize_behaviors() :
	var points = 10
	while points > 0 :
		var rand = randf() * 100
		if in_range(rand, 0,100) :
			add_behavior("go_to_center")
			points -= randf()*15
	

func in_range(value, low, high) :
	return value <= high && value >= low

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

func clear_behaviors() :
	behaviors.clear()

func add_behavior(b : String) :
	behaviors.append(b)

## Behaviors

func go_to_center(delta : float) :
	rotation += -7 * delta
	position -= (position - Vector2(550,300)) * delta * 0.8
