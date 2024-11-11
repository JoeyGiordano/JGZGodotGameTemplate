extends Node2D

@onready var cs : ComputeShader = $ComputeShader
@onready var rect : GolRect = $ColorRect
@onready var label : Label = $Label

var process_frame : int = 0
var frame : int = 0
var vals := PackedInt32Array(	[0,1,0,0,
								 0,1,0,0,
								 1,0,1,0,
								 0,0,1,0,])

func _ready():
	#feed vals into the compute shader and begin the next computation
	cs.set_inputs(vals)
	cs.submit()
	#send new vals to the display shader
	rect.set_vals(vals)
	#label
	label.text = "Frame: 0"

func _process(delta):
	#process_frame += 1
	#if process_frame == 60 :
		#process_frame = 0
		#step_simulation()
		
	if Input.is_action_just_pressed("step") :
		step_simulation()

func step_simulation() :
	#get the output from the compute shader
	vals = cs.sync_and_get_output()
	#send new vals to the display shader
	rect.set_vals(vals)
	#feed new vals back into the compute shader and begin the next computation
	cs.set_inputs(vals)
	cs.submit()
	
	#label
	frame += 1
	label.text = "Frame: " + str(frame)
