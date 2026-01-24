extends Button

## Add this script to a button to make it automagically switch shell scenes / overlay panels
## What it can do:
##  - Switch shell scenes
##  - Open overlay panel
##  - Switch overlay panels
##  - Close overlay panel
##  - Close overlay panel when switching shell scenes
##  - Simulate button press with keyboard input

## When true, pressing the button will close the current overlay panel and do nothing else (it will ignore all other export variables).
@export var just_close_overlay_panel : bool
## Name of the shell scene or overlay panel scene that this button will switch to (use the var name in Ref).
@export var switch_to : String
## If switch_to is a shell scene, set this to false. If switch_to is an overlay panel, set this to true.
@export var is_overlay_panel : bool
## When true, closes the current overlay panel when switching between shell scenes (if is_overlay_panel is set to true, this will do nothing). 
@export var also_close_overlay_panel : bool = true
## Debug. Allows faster skipping around, simulate pressing the button by pressing DEBUG_SKIP. This should only be on for one button per scene.
@export var allow_quick_key : bool

func _ready() :
	# connect the button's pressed signal to on_pressed()
	connect("pressed", _on_pressed)

func _process(_delta):
	if Debug.IS_DEBUG_ON() && allow_quick_key && Input.is_action_just_pressed("DEBUG_SKIP"):
		_on_pressed()

func _on_pressed() :
	if just_close_overlay_panel :
		# pressed in a shell scene w/o overlay panel -> does nothing
		# pressed in a shell scene w/ overlay panel -> closes the overlay panel
		# pressed in an overlay panel -> closes the overlay panel
		ShellSceneManager.close_overlay_panel()
		return
	
	if is_overlay_panel : #switch_to is an overlay panel
		# pressed in a shell scene w/o overlay panel -> opens an overlay panel
		# pressed in a shell scene w/ overlay panel -> switches the overlay panel
		# pressed in an overlay panel -> switches the overlay panel
		ShellSceneManager.switch_overlay_panel(Ref.get(switch_to))
		return
	else : #switch_to is a shell scene
		# switches shell scenes, if also_close_overlay_panel, closes any open overlay panel
		if also_close_overlay_panel : 
			ShellSceneManager.close_overlay_panel()
		ShellSceneManager.switch_active_scene(Ref.get(switch_to))
		return
