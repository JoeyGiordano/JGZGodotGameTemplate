extends Node
class_name _ShellSceneManager

### AUTOLOAD

### ShellSceneManager ###
## Manages shell scene switching and overlay panels.

func switch_active_scene(new_shell_scene : PackedScene, close_overlay_panels : bool = true) :
	# replace the scene in the ActiveSceneHolder with a newly instantiated scene from PackedScene scene
	# use Reference to get scenes instead of loading them yourself! Ref.level_0 or Ref.get("level_0)
	if close_overlay_panels :
		close_overlay_panel()
	Utility.replace_scene_in_holder(Global.ShellSceneHolder, new_shell_scene)

func switch_overlay_panel(new_overlay_panel : PackedScene) :
	Utility.replace_scene_in_holder(Global.OverlayPanelHolder, new_overlay_panel)

func close_overlay_panel() :
	Utility.remove_scene_in_holder(Global.OverlayPanelHolder)
