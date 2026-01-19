extends Node
class_name GameContainer

#easy way to access the GameContainer from other nodes
static var GAME_CONTAINER : GameContainer

#There should only ever be one active scene (menu or stage) and it will be the only child of the ActiveSceneHolder node
@onready var ActiveSceneHolder = $ActiveSceneHolder
#Other scenes can be overlay panels (UI, eg pause menu) and can be put in the OverlayPanels node
@onready var OverlayPanels = $OverlayPanels
#The player nodes are instantiated in the Players node, they can be hidden and frozen when necessary (if the player nodes do not need to persist this structure is not necessary)
@onready var Players = $Players

#Scenes
@onready var main_menu : PackedScene = preload("res://scenes/statics/main_menu.tscn")
@onready var credits : PackedScene = preload("res://scenes/statics/credits.tscn")
@onready var instructions : PackedScene = preload("res://scenes/statics/instructions.tscn")
@onready var cutscene1 : PackedScene = preload("res://scenes/cutscenes/cutscene1.tscn")
@onready var game_over : PackedScene = preload("res://scenes/statics/game_over.tscn")
@onready var stage1 : PackedScene = preload("res://scenes/stages/stage1.tscn")
@onready var stage2 : PackedScene = preload("res://scenes/stages/stage2.tscn")
@onready var stage3 : PackedScene = preload("res://scenes/stages/stage3.tscn")
@onready var scene_dict = {
	"main_menu" : main_menu,
	"credits" : credits,
	"instructions" : instructions,
	"cutscene1" : cutscene1,
	"game_over" : game_over,
	"stage1" : stage1,
	"stage2" : stage2,
	"stage3" : stage3
}


#### METHODS ####

func _ready():
	#set up the singleton (not an autoload)
	GAME_CONTAINER = self
	pass

func switch_to_scene(scene_name : String) :
	#switch to a scene with the name scene_name
	switch_active_scene(get_scene(scene_name))

func switch_active_scene(scene : PackedScene) :
	#replace the scene in the ActiveSceneHolder with a newly instantiated PackedScene scene
	ActiveSceneHolder.get_child(0).queue_free()
	var s = scene.instantiate()
	ActiveSceneHolder.add_child(s)

func get_scene(scene_name : String) -> PackedScene:
	#return the PackedScene with the name scene_name, or return a random stage
	if scene_name == "random_stage" :
		return get_random_stage()
	if !scene_dict.has(scene_name) : 
		print("Scene " + scene_name + " is not in scene dict.")
		return main_menu
	return scene_dict[scene_name]

func get_random_stage() -> PackedScene:
	#return a random stage
	var r = int(randf() * 4)
	if r == 0 : return stage1
	if r == 1 : return stage2
	else : return stage3
