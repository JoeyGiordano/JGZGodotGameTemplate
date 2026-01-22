extends Button

## Add this script to a button to make it automagically switch shell scenes / overlay panels
## Can do:
##  - Switch shell scenes
##  - Open overlay panel
##  - Switch overlay panels
##  - Close overlay panel
##  - Close overlay panel when switching shell scenes
##  - Simulate button press with keyboard input

@export var just_close_overlay_panel : bool # when true, pressing the button will close the current overlay panel and do nothing else (ignoring all other export variables)
@export var switch_to : String # name of the scene that this button will switch to (shell scene or overlay panel scene)
@export var is_overlay_panel : bool # switch_to is a shell scene -> set this to false, switch_to is an overlay panel -> set this to true
@export var also_close_overlay_panel : bool = true # when true, closes the current overlay panel when switching between shell scenes (if is_overlay_panel is set to true, this will do nothing) 
@export var 	quick_key : bool #debug, allows faster skipping around, simulate pressing the button by pressing a "1", should only be on for one button per scene

func _ready() :
	#connect the button's pressed signal to on_pressed()
	connect("pressed", on_pressed)

func _process(_delta):
	if quick_key && Input.is_action_just_pressed("DEBUG_SKIP"):
		on_pressed()

func on_pressed() :
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
