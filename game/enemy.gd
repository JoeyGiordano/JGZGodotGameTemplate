extends Node2D
class_name Enemy

@onready var sprite : Sprite2D = $Sprite2D

@export var state : int = 0 #0 red, 1 green, 2 blue

var in_game : bool = false

var behaviors : Array[String]
var behavior_frame : int = -1
var new_behavior_queued : bool = false

@export var waiting : bool = false

var spawn_T : float = 1 # GC.T when this enemy was created
var difficulty : float = 1

var behaviors_increase : float = 0.2 #behaviors per difficulty

var time_alive : float = 0

func _enter_tree() :
	set_multiplayer_authority(1)

func _ready() :
	$Area2D.area_entered.connect(_on_area_entered)
	change_state()
	spawn_T = GameContainer.GC.T
	difficulty = sqrt(spawn_T)/10

func _process(delta):
	update_color()
	time_alive += delta
	
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
	waiting = true
	await get_tree().create_timer(randf_range(1,2)).timeout #time waiting between behaviors 
	waiting = false
	behavior_frame = 0
	queue_new_random_behaviors()
	await get_tree().create_timer(randf_range(4,15)).timeout #time doing behavior
	behavior_loop()

func queue_new_random_behaviors() :
	new_behavior_queued = true

func new_random_behaviors() :
	for i in range(0,int(difficulty/behaviors_increase) + 1) :
		add_random_behavior()
	
func add_random_behavior() :
	var rand = randf() * 100
	if rand < 5 : 
		add_behavior("go_to_center")
	elif rand < 32 :
		add_behavior("wiggle")
	elif rand < 50 :
		add_behavior("wiggle")
	elif rand < 92 :
		add_behavior("go_to_random")
	else :
		add_behavior("change_state_constantly")

func _on_area_entered(area : Area2D) :
	if !is_multiplayer_authority() : return
	
	if area.get_parent() is Player : return #if we fought a player, the player will handle it
	
	var result = Player.resolve_interaction(state, area.get_parent().state)
	if result == "Uwin" : #if we won, the other one will kill itself
		die()

func die() :
	sprite.modulate = Color.BLACK
	rpc("_die")

@rpc("any_peer", "call_local")
func _die() :
	state = 3 #so no death
	in_game = false
	clear_behaviors()
	await get_tree().create_timer(2).timeout
	queue_free()

func update_color() :
	if waiting : modulate.a = 0.45
	else : modulate.a = 1.0
	
	match(state) :
		0 : sprite.modulate = Color.RED
		1 : sprite.modulate = Color.GREEN
		2 : sprite.modulate = Color.BLUE
		3 : sprite.modulate = Color.BLACK
		
	visible = true

func clear_behaviors() :
	behaviors.clear()

func add_behavior(b : String) :
	behaviors.append(b)

func change_state() :
	state = (state+randi()%2+1)%3 #gives one of other two states

## Behaviors

func go_to_center(_delta : float) :
	position -= position.normalized() * speed * difficulty * _delta #center is 0,0

var target_pos : Vector2
var speed : float = 50
func go_to_random(_delta : float) :
	if behavior_frame == 0 :
		target_pos = 600*Vector2(randf()*2-1, randf()*2-1)
	position -= (position + target_pos).normalized() * speed * difficulty * _delta

func change_state_constantly(_delta : float) :
	if behavior_frame%10 == 0 :
		change_state()

var wiggle_dir : Vector2
var t : float
func wiggle(_delta : float) :
	if behavior_frame == 0 :
		var rand = randf_range(0,2*PI)
		wiggle_dir = Vector2(cos(rand), sin(rand))
	position += wiggle_dir * sin(t) * 120 * _delta
	t += 0.09

var wobble_dir : Vector2
var t2 : float
func wobble(_delta : float) :
	if behavior_frame == 0 :
		var rand = randf_range(0,2*PI)
		wobble_dir = Vector2(cos(rand), sin(rand))
	position += wobble_dir * sin(t2) * 200 * _delta
	t2 += 0.03
	
