extends Node

## Add this script to a button to
##  a) make it automagically switch shell scenes or overlay panels
##  b) make it emit a SignalBus signal when pressed
##
## What the shell scene switcher can do:
##  - Switch shell scenes
##  - Open overlay panel
##  - Switch overlay panels
##  - Close overlay panel
##  - Close overlay panel when switching shell scenes
##  - Simulate button press with keyboard input

## When true, a signal from SignalBus is emitted according to the settings below.
@export var emit_signal_ : bool = false
## When true, scene switching is executed according to the settings below.
@export var switch_scene : bool = false
## Debug. Allows faster skipping around, simulate pressing the button by pressing DEBUG_SKIP. This should only be on for one button per scene.
@export var allow_quick_key : bool

## Everything in this group is irrelevant if do_emit is set to false.
@export_group("Signal Emission")
## The name of the signal in SignalBus to emit.
@export var signal_to_emit : String
## Whether to emit the signal before or after the scene switch.
@export_enum("Before:0", "After:1") var emit_order : int = 0

## Everything in this group is irrelevant if do_scene_switch is set to false.
@export_group("Scene Switching")
## When true, pressing the button will close the current overlay panel and do nothing else (it will ignore all other export variables).
@export var just_close_overlay_panel : bool
## Name of the shell scene or overlay panel scene that this button will switch to (use the var name in Ref).
@export var switch_to : String
## If switch_to is a shell scene, set this to false. If switch_to is an overlay panel, set this to true.
@export var is_overlay_panel : bool
## When true, closes the current overlay panel when switching between shell scenes (if is_overlay_panel is set to true, this will do nothing). 
@export var also_close_overlay_panel : bool = true

func _ready() :
	# connect the button's pressed signal to on_pressed()
	connect("pressed", _on_pressed)

func _process(_delta):
	if Debug.IS_DEBUG_ON() && allow_quick_key && Input.is_action_just_pressed("DEBUG_SKIP"):
		_on_pressed()

func _on_pressed() :
	if emit_signal_ && emit_order == 0 :
		emit_assigned_signal()
	if switch_scene :
		switch_scene_()
	if emit_signal_ && emit_order == 1 :
		emit_assigned_signal()

func emit_assigned_signal() :
	SignalBus.emit_signal(signal_to_emit)

func switch_scene_() :
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
