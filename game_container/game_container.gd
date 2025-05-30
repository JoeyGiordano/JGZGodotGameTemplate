extends Node
class_name GameContainer

#easy way to access the GameContainer from other nodes
static var GC : GameContainer

#There should only ever be one active scene (menu or stage) and it will be the only child of the ActiveSceneHolder node
@onready var ActiveSceneHolder = $ActiveSceneHolder
#Manager is the coder facing script
@onready var manager : Manager = $Manager

#### METHODS ####

func _ready() :
	#set up the singleton (not an autoload)
	GC = self

func _process(_delta):
	#quit for DEBUG purposes
	if Input.is_action_just_pressed("DEBUG_QUIT") :
		get_tree().quit()

func switch_to_scene(scene_path : String) :
	#switch to the scene with the path scene_path
	switch_active_scene(get_scene_from_path(scene_path))

func switch_active_scene(scene : PackedScene) :
	#replace the scene in the ActiveSceneHolder with a newly instantiated PackedScene scene
	ActiveSceneHolder.get_child(0).queue_free() #sets the node to be deleted
	ActiveSceneHolder.remove_child(get_child(0)) #unchilds the node, undisplaying it
	var s = scene.instantiate() #creates a new instance of the new scene
	ActiveSceneHolder.add_child(s) #adds the new scene instance as a child, displaying it

func get_scene_from_path(scene_path : String) -> PackedScene :
	return load(scene_path) #if you're getting an error here, make sure the scene you're trying to load exists/the name is spelled right
