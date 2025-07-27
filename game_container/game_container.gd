extends Node
class_name GameContainer

#easy way to access the GameContainer from other nodes
static var GC : GameContainer

#There should only ever be one active scene (menu or stage) and it will be the only child of the ActiveSceneHolder node
@onready var ActiveSceneHolder = $ActiveSceneHolder
#For easy access from other scenes
@onready var OpponentSceneHolder = $OpponentSceneHolder

#Scenes
@onready var main_menu : PackedScene = preload("res://scenes/shell_scenes/main_menu.tscn")
@onready var credits : PackedScene = preload("res://scenes/shell_scenes/credits.tscn")
@onready var instructions : PackedScene = preload("res://scenes/shell_scenes/instructions.tscn")
@onready var connect_scene : PackedScene = preload("res://scenes/shell_scenes/connect.tscn")
@onready var player_field_1 : PackedScene = preload("res://game/player_field.tscn")

@onready var scene_dict = {
	"main_menu" : main_menu,
	"credits" : credits,
	"instructions" : instructions,
	"connect" : connect_scene,
	"player_field_1" : player_field_1
}

var start_T : float = 0
var T : float = 0 # time since the round started in seconds
var score : int = 0

#### METHODS ####

func _ready():
	#set up the singleton (not an autoload)
	GC = self
	pass

func _process(_delta):
	#quit if Q pressed - DEBUG
	if Input.is_key_pressed(KEY_Q) :
		get_tree().quit()
	
	T = Time.get_ticks_msec()/1000. - start_T

func switch_to_scene(scene_name : String) :
	#switch to a scene with the name scene_name
	_switch_active_scene(get_scene(scene_name))

func _switch_active_scene(scene : PackedScene) :
	#replace the scene in the ActiveSceneHolder with a newly instantiated PackedScene scene
	ActiveSceneHolder.get_child(0).queue_free()
	var s = scene.instantiate()
	ActiveSceneHolder.add_child(s)

func get_scene(scene_name : String) -> PackedScene:
	#return the PackedScene with the name scene_name
	if !scene_dict.has(scene_name) : 
		print("Scene " + scene_name + " is not in scene dict.")
		return main_menu
	return scene_dict[scene_name]

func start_game_T() :
	start_T = Time.get_ticks_msec()/1000
