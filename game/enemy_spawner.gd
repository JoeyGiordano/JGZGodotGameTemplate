extends Node2D
class_name EnemySpawner

@onready var enemy_scene : PackedScene = preload("res://game/enemy.tscn")
@export var enemies : Node2D

func _enter_tree() :
	set_multiplayer_authority(1) #server controlled
	
func start_game() :
	if !is_multiplayer_authority() : return
	spawn_loop()

func spawn_loop() :
	new_position()
	spawn_enemy()
	var next_wait_time = get_next_wait_time()
	await get_tree().create_timer(next_wait_time).timeout
	spawn_loop()

func spawn_enemy() :
	var e : Enemy = enemy_scene.instantiate()
	e.set_multiplayer_authority(1)
	enemies.add_child(e,true)
	e.state = randi()%3 #0,1,2
	e.position = position
	e.in_game = true

func new_position() :
	var v = Vector2(2*randf()-1,2*randf()-1)
	position = 500 * v + 50 * randf() * v

func get_next_wait_time() -> float: 
	return randf_range(3,4)
