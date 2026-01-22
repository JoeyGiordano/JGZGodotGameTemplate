extends Node
class_name _Global

### AUTOLOAD

### Global ###
## Stores nodes that are always present (the main children of GameContainer).

#These nodes always exist when the game is running because they are part of the GameContainer Scene
@onready var GameContainer : Node = get_node("/root/GameContainer") #The only child of /root. Contains everything
@onready var ShellSceneHolder : Node = get_node("/root/GameContainer/ShellSceneHolder") #There should always be only one active shell scene (menu scene) and it should be the only child of the ShellSceneHolder node
@onready var OverlayPanelHolder : Node = get_node("/root/GameContainer/OverlayPanelHolder") #There should always be one or zero active overlay panels (UI, eg pause menu) and it should be the only child of the OverlayPanelHolder node
@onready var Game : Node = get_node("/root/GameContainer/Game") #Where all parts of the game go (everything that's "in game" or not a shell scene)
@onready var LevelHolder : Node = get_node("/root/GameContainer/Game/LevelHolder") #There should always be one or zero active level scenes and it should be the only child of the LevelHolder node
@onready var PlayerTanks : Node = get_node("/root/GameContainer/Game/PlayerTanks")
@onready var NpcTanks : Node = get_node("/root/GameContainer/Game/NpcTanks")
@onready var Entities : Node = get_node("/root/GameContainer/Game/Entities")

func CurrentShellScene() -> Node :
	return ShellSceneHolder.get_child(0)
	
func CurrentLevel() -> Node :
	if LevelHolder.get_child_count() == 0 :
		print("Global.get_active_level() : no active level")
		return
	return LevelHolder.get_child(0)
