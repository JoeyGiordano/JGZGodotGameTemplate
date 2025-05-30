extends Button

@export var function_name : String

@export var parameters : Array

func _ready() :
	#connect the button's pressed signal to on_pressed()
	connect("pressed", on_pressed)

func on_pressed() :
	if !GameContainer.GC.manager.has_method(function_name) :
		push_error("Function name attached to button \"" + text + "\" does not exist. Check for spelling or create a function")
		return
	if parameters.size() != GameContainer.GC.manager.get_method_argument_count(function_name) :
		push_error("Function attached to button \"" + text + "\" has been called with the incorrect number of parameters. Check the parameters list and the method definition.")
	
	#had to do it this way because call_deferred doesn't take an array as a substitute for a variable number of parameters
	Callable(GameContainer.GC.manager, function_name).callv(parameters)
