extends Node2D

@onready var cs : ComputeShader = $ComputeShader
@onready var rect : GolRect = $Sprite2D
@onready var label : Label = $Label

var process_frame : int = 0
var frame : int = 0
var vals : PackedInt32Array
var dims := PackedInt32Array([16,16]) #IMPORTANT NOTE BELOW
#NOTE 
#when changing the dimensions you must also change the vals array size in the display shader to dims[0]*dims[1]
#additionally, dims[0]*dims[1] must be divisible by 16 OR the compute shader workgroups and local_size must be changed

func _ready():
	prepare_default_starting_vals()
	
	#set up the compute shader
	cs.setup_compute_shader(dims)
	
	#feed vals into the compute shader and begin the next computation
	cs.set_inputs(vals)
	cs.submit()
	
	#set the dimensions of the display shader
	rect.set_dims(dims)
	#send the vals to the display shader
	rect.set_vals(vals)
	
	#label
	label.text = "Frame: 0"

func _process(delta):
	handle_mouse_input()
	
	if Input.is_key_pressed(KEY_F) :
		process_frame += 1
		if process_frame >= 25 :
			process_frame = 0
			step_simulation()
		
	if Input.is_key_pressed(KEY_G) :
		process_frame += 1
		if process_frame >= 8 :
			process_frame = 0
			step_simulation()
		
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

func prepare_default_starting_vals() :
	var temp : Array[int] = []
	temp.resize(dims[0] * dims[1])
	temp.fill(0)
	vals = PackedInt32Array(temp)

func handle_mouse_input() :
	if Input.is_action_pressed("paint") :
		var mouse := get_global_mouse_position()
		var mouse_rel_rect := mouse - rect.topLeft.global_position
		var rect_scale := rect.bottomRight.global_position - rect.topLeft.global_position
		var gol_coords := Vector2(floor(dims[0] * mouse_rel_rect.x / rect_scale.x), floor(dims[1] * mouse_rel_rect.y / rect_scale.y))
		if (gol_coords.x < 0 || gol_coords.x >= dims[0] || gol_coords.y < 0 || gol_coords.y >= dims[1]) :
			return
		var gol_index = gol_coords.x + gol_coords.y * dims[0]
		if Input.is_key_pressed(KEY_A) :
			vals[gol_index] = 0
		else :
			vals[gol_index] = 1
		rect.set_vals(vals)
		#stop the GPU from working so the input can be changed
		cs.sync_and_get_output()
	
	if Input.is_action_just_released("paint") :
		#resubmit to the GPU when the painting is done
		cs.set_inputs(vals)
		cs.submit()
		
		
		
		
		
