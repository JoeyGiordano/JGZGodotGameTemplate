extends Node2D
class_name Enemy

@onready var sprite : Sprite2D = $Sprite2D

@export var state : int = 0 #0 red, 1 green, 2 blue

var in_game : bool = false

var behaviors : Array[String]
var behavior_frame : int = -1
var new_behavior_queued : bool = false

var waiting : bool = false
var changing_state : bool = false

func _enter_tree():
	set_multiplayer_authority(1)

func _ready():
	$Area2D.area_entered.connect(_on_area_entered)

func _process(delta):
	update_color()
	
	if waiting : rotation += -2 * delta
	else : rotation += -7 * delta
	
	if !is_multiplayer_authority() : return
	
	if !in_game : return
	
	if behavior_frame == -1 : behavior_loop() #start the behavior loop if in game and it hasn't been started yet
	
	if new_behavior_queued :
		new_random_behaviors()
		new_behavior_queued = false
	
	for b : String in behaviors :
		call(b, delta)
	
	behavior_frame += 1

func behavior_loop() :
	clear_behaviors()
	modulate.a = 0.5
	waiting = true
	await get_tree().create_timer(randf_range(1,2)).timeout
	waiting = false
	behavior_frame = 0
	modulate.a = 1
	queue_new_random_behaviors()
	await get_tree().create_timer(randf_range(4,15)).timeout
	behavior_loop()

func queue_new_random_behaviors() :
	new_behavior_queued = true

func new_random_behaviors() :
	var points = 15
	while points > 5 :
		var rand = randf() * 100
		if rand < 30 : 
			points = try_add_behavior("go_to_center", points, 6)
		if rand < 60 :
			points = try_add_behavior("go_to_random", points, 6)
		elif rand < 95 :
			points = try_add_behavior("change_state_behavior", points, 3)
		elif rand < 100 :
			points = try_add_behavior("change_state_constantly", points, 10)
		points *= 0.8 #so that the while can't run forever, could use subtract but points could get big

func try_add_behavior(behavior : String, points_remaining : float, point_cost : float) -> float :
	if point_cost < points_remaining : return points_remaining
	add_behavior(behavior)
	return points_remaining - point_cost


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
	in_game = false
	clear_behaviors()
	await get_tree().create_timer(2).timeout
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

func start_state_change(time : float) :
	if changing_state : return
	changing_state = true
	modulate.a = 0.5
	if time == -1 : time = 1.1
	await get_tree().create_timer(time).timeout
	change_state()
	changing_state = false
	modulate.a = 1
	
func change_state() :
	state = (state+randi()%2+1)%3 #gives one of other two states

## Behaviors

func go_to_center(_delta : float) :
	position -= position * _delta * 0.8 #center is 0,0

var target_pos : Vector2
func go_to_random(_delta : float) :
	if behavior_frame == 0 :
		target_pos = 600*Vector2(randf()*2-1, randf()*2-1)
	position -= (position + target_pos) * _delta * 0.5

func change_state_behavior(_delta : float) :
	if behavior_frame == 0 :
		start_state_change(-1)
	position += 3*Vector2(randf()-0.5,randf()-0.5)

func change_state_constantly(_delta : float) :
	if behavior_frame%10 == 0 :
		change_state()
