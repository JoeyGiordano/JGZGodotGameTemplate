extends Node2D
class_name Player

@onready var sprite : Sprite2D = $Sprite2D

var speed : float = 200
var cooldown : float = 1.1

var in_play : bool = false
@export var state : int = 0 #0 red, 1 green, 2 blue
@export var switch_ready : bool = true
@export var dead : bool = false
var game_over : bool = false

func _enter_tree():
	set_multiplayer_authority(int(name))

func _ready():
	update_color()
	$Area2D.area_entered.connect(_on_area_entered)

func _process(delta):
	update_color()
	
	if !is_multiplayer_authority() : return
	
	rotation += delta * 3 #spin
	
	if !in_play : return
	
	rotation += delta * 3 #SPIN FASTER
	
	var movement : Vector2 = Vector2(Input.get_axis("left","right"), Input.get_axis("up","down"))
	movement = movement.normalized()
	position += movement * speed * delta
	
	if switch_ready && Input.is_action_just_pressed("switch") :
		switch_ready = false
		await get_tree().create_timer(cooldown).timeout
		state = (state+(randi()%2)+1)%3 #gives rand between two other states
		switch_ready = true

func update_color() :
	if dead : 
		modulate.a = 1.0
		sprite.modulate = Color.BLACK
		return
	
	if switch_ready : modulate.a = 1.0 #note that this is player modulate (so it doesn't combine with color changes)
	else : modulate.a = 0.5
	
	match(state) :
		0 : sprite.modulate = Color.RED
		1 : sprite.modulate = Color.GREEN
		2 : sprite.modulate = Color.BLUE

func die() :
	if game_over : return
	rpc("game_over_")
	if dead : return
	dead = true
	state = 3 #so no death
	await get_tree().create_timer(3).timeout
	rpc("restart")

@rpc("call_local")
func game_over_() :
	game_over = true

@rpc("call_local")
func restart() :
	#start the scenes again
	GameContainer.GC.switch_to_scene("player_field_1")
	GameContainer.GC.switch_to_opponent_scene("opponent_field_1")

func _on_area_entered(area : Area2D) :
	if !is_multiplayer_authority() : return
	var result = resolve_interaction(state, area.get_parent().state)
	
	if area.get_parent() is Player : #if we fought a player, the other player is checking if it won and both outcomes will be taken care of and then properly synced later
		if result == "Uwin" : die()
	else : #if we fought an enemy, we call its death method here (no call conflict bc the other client was already excluded from this method for this player)
		if result == "Iwin" :
			area.get_parent().die()
		if result == "Uwin" :
			die()
	
	
static func resolve_interaction(state_ : int, statex : int) -> String :
	#statex is the other part of the interactions state
	#returns "Iwin" "Uwin" "Tie" or "error"
	if state_ == 0 :
		if statex == 1 : return "Iwin"
		if statex == 2 : return "Uwin"
	elif state_ == 1 :
		if statex == 0 : return "Uwin"
		if statex == 2 : return "Iwin"
	elif state_ == 2 :
		if statex == 0 : return "Iwin"
		if statex == 1 : return "Uwin"
	return "error or post death"
