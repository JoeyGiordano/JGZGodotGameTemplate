extends Node
class_name _Global

### AUTOLOAD

### Global ###
## Stores nodes that are always present when the game is run from the GameContainer

## Is the game running from the GameContainer (as opposed to test running an individual scene)
@onready var IS_RUNNING_FROM_GAME_CONTAINER : bool = has_node("/root/GameContainer")

# These nodes always exist when the game is running from GameContainer
## The only child of /root. Contains everything.
var GameContainer : Node
## Holds the active shell scene. There should always be only one active shell scene.
var ShellSceneHolder : Node
## Holds the active overlay panel. There should always be one or zero active overlay panels.
var OverlayPanelHolder : Node
## Holder for parts of the game.
var Game : Node

func _ready() -> void:
	if IS_RUNNING_FROM_GAME_CONTAINER : # check if the game is running from the GameContainer (as opposed to test running an individual scene)
		# doing this here instead of @onready to prevent errors when running a scene not through the game container
		GameContainer = get_node("/root/GameContainer")
		ShellSceneHolder = GameContainer.get_node("ShellSceneHolder")
		OverlayPanelHolder = GameContainer.get_node("OverlayPanelHolder")
		Game = GameContainer.get_node("Game")

func get_current_shell_scene() -> Node :
	return ShellSceneHolder.get_child(0)

func get_current_overlay_panel() -> Node :
	if OverlayPanelHolder.get_child_count() == 0 :
		print("Global.get_current_overlay_panel() : no active overlay panel")
		return
	return OverlayPanelHolder.get_child(0)
