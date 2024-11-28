extends Node2D

@onready var cs : ComputeShader = $ComputeShader
@onready var rect1 : GolRect = $Field1Rect
@onready var rect2 : GolRect = $Field2Rect
@onready var label : Label = $Label

var process_frame : int = 0
var frame : int = 0
var dims := PackedInt32Array([16,16]) #IMPORTANT NOTE BELOW
#NOTE 
#when changing the dimensions you must also change the vals array size in the display shader to dims[0]*dims[1]
#additionally, dims[0]*dims[1] must be divisible by 16 OR the compute shader workgroups and local_size must be changed
var field1 : PackedFloat32Array
var field2 : PackedFloat32Array

func _ready():
	set_to_clear_board()
	
	#set up the compute shader
	cs.setup_compute_shader(dims)
	
	#feed vals into the compute shader and begin the next computation
	cs.set_inputs(field1,field2)
	cs.submit()
	
	#set the dimensions of the display shader
	rect1.set_dims(dims)
	rect2.set_dims(dims)
	#send the vals to the display shader
	rect1.set_field(field1)
	rect2.set_field(field2)
	
	#label
	label.text = "Frame: 0"

func _process(delta):
	handle_paint_input()
	
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
		
	if Input.is_key_pressed(KEY_T) :
		frame = 0
		label.text = "Frame: 0"

func step_simulation() :
	#get the output from the compute shader
	cs.sync()
	field1 = cs.field1_OUT
	field2 = cs.field2_OUT
	#send new vals to the display shader
	rect1.set_field(field1)
	rect2.set_field(field2)
	#feed new vals back into the compute shader and begin the next computation
	cs.set_inputs(field1,field2)
	cs.submit()
	
	#label
	frame += 1
	label.text = "Frame: " + str(frame)

func set_to_clear_board() :
	var temp : Array[int] = []
	temp.resize(dims[0] * dims[1])
	temp.fill(0)
	field1 = PackedFloat32Array(temp)
	var temp2 : Array[int] = []
	temp2.resize(dims[0] * dims[1])
	temp2.fill(0)
	field2 = PackedFloat32Array(temp2)

func handle_paint_input() :
	if Input.is_action_pressed("paint") :
		var mouse := get_global_mouse_position()
		var mouse_rel_rect := mouse - rect1.topLeft.global_position
		var rect_scale := rect1.bottomRight.global_position - rect1.topLeft.global_position
		var gol_coords := Vector2(floor(dims[0] * mouse_rel_rect.x / rect_scale.x), floor(dims[1] * mouse_rel_rect.y / rect_scale.y))
		if !(gol_coords.x < 0 || gol_coords.x >= dims[0] || gol_coords.y < 0 || gol_coords.y >= dims[1]) :
			var gol_index = gol_coords.x + gol_coords.y * dims[0]
			if Input.is_key_pressed(KEY_A) : #erase
				field1[gol_index] = 0
			elif Input.is_key_pressed(KEY_E) : #paint negative
				field1[gol_index] -= 0.05
			else :      #paint
				field1[gol_index] += 0.05
			if Input.is_key_pressed(KEY_X) : #clear
				set_to_clear_board()
			rect1.set_field(field1)
			#stop the GPU from working so the input can be changed
			cs.sync()
	
	#for the second square
	if Input.is_action_pressed("paint") :
		var mouse := get_global_mouse_position()
		var mouse_rel_rect := mouse - rect2.topLeft.global_position
		var rect_scale := rect2.bottomRight.global_position - rect2.topLeft.global_position
		var gol_coords := Vector2(floor(dims[0] * mouse_rel_rect.x / rect_scale.x), floor(dims[1] * mouse_rel_rect.y / rect_scale.y))
		if !(gol_coords.x < 0 || gol_coords.x >= dims[0] || gol_coords.y < 0 || gol_coords.y >= dims[1]) :
			var gol_index = gol_coords.x + gol_coords.y * dims[0]
			if Input.is_key_pressed(KEY_A) : #erase
				field2[gol_index] = 0
			elif Input.is_key_pressed(KEY_E) : #paint negative
				field2[gol_index] -= 0.05
			else :      #paint
				field2[gol_index] += 0.05
			if Input.is_key_pressed(KEY_X) : #clear
				set_to_clear_board()
			rect2.set_field(field2)
			#stop the GPU from working so the input can be changed
			cs.sync()
	
	if Input.is_action_just_released("paint") :
		#resubmit to the GPU when the painting is done
		cs.set_inputs(field1,field2)
		cs.submit()
		
		
		
		
