extends ColorRect
class_name GolRect

var vals : Array[int] = [0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0]

var frame : int = 0;

func _ready():
	material.set_shader_parameter("width", 4.0)
	material.set_shader_parameter("height", 4.0)
	material.set_shader_parameter("vals", vals)

func _process(delta):
	#frame += 1
	#if frame == 30 :
		#for i in vals.size() :
			#vals[i] = 1-vals[i]
		#material.set_shader_parameter("vals", vals)
		#frame=0
	pass

func set_vals(new_vals : PackedInt32Array) :
	#create a new int array
	vals = []
	#fill it with the info from the packed int array
	for i in range(new_vals.size()):
		vals.append(new_vals[i])
	#set the shader param to the new vals
	material.set_shader_parameter("vals", vals)
