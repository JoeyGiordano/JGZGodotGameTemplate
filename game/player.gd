extends Node2D

@onready var sprite : Sprite2D = $Sprite2D

var speed : float = 200
var cooldown : float = 1.3

var in_play : bool = false
@export var state : int = 0 #0 rock, 1 paper, 2 siscors
@export var switch_ready : bool = true

func _ready():
	update_color()

func _process(delta):
	if !is_multiplayer_authority() : return
	
	if !in_play : return
	
	update_color()
	
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
