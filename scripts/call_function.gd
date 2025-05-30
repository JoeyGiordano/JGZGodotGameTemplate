extends Button

@export var function_name : String

func _ready() :
	#connect the button's pressed signal to on_pressed()
	connect("pressed", on_pressed)

func on_pressed() :
	if !GameContainer.GC.manager.has_method(function_name) :
		push_error("function name attached to button \"" + text + "\" does not exist. Check for spelling or create a function")
		return
	GameContainer.GC.manager.call_deferred(function_name)
