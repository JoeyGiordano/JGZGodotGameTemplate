extends Button

@export var switch_to : String #name of the scene that this button will switch to

func _ready() :
	#connect the button's pressed signal to on_pressed()
	connect("pressed", on_pressed)

func on_pressed() :
	#tell the GameContainer to switch the scene to the scene with the name switch_to
	GameContainer.GC.switch_to_scene(switch_to)
