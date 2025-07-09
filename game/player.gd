extends Node2D

@onready var sprite : Sprite2D = $Sprite2D

var speed : float = 200
var cooldown : float = 1.3

var in_play : bool = false
@export var state : int = 0 #0 rock, 1 paper, 2 siscors
@export var switch_ready : bool = true
var dead : bool = false
var game_over : bool = false

func _ready():
	update_color()
	$Area2D.area_entered.connect(_on_area_entered)

func _process(delta):
	if !is_multiplayer_authority() : return
	
	rotation += delta * 3 #spin
	
	if !in_play : return
	
	rotation += delta * 4 #SPIN FASTER
	
	if !dead : update_color()
	
	var movement : Vector2 = Vector2(Input.get_axis("left","right"), Input.get_axis("up","down"))
	movement = movement.normalized()
	position += movement * speed * delta
	
	if switch_ready && Input.is_action_just_pressed("switch") :
		switch_ready = false
		await get_tree().create_timer(cooldown).timeout
		state = (state+(randi()%2)+1)%3 #gives rand between two other states
		switch_ready = true

func update_color() :
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
	sprite.modulate = Color.BLACK
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
	var statex = area.get_parent().state
	if state == 0 :
		if statex == 1 : die()
		if statex == 2 : area.get_parent().die()
	if state == 1 :
		if statex == 2 : die()
		if statex == 0 : area.get_parent().die()
	if state == 2 :
		if statex == 0 : die()
		if statex == 1 : area.get_parent().die()
			
			
