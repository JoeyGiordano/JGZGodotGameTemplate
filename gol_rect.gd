extends Sprite2D
class_name GolRect

@onready var topLeft : Node2D = $TopLeft
@onready var bottomRight : Node2D = $BottomRight

var vals : Array[int]

func set_dims(dims : PackedInt32Array):
	material.set_shader_parameter("width", float(dims[0]))
	material.set_shader_parameter("height", float(dims[1]))

func set_vals(new_vals : PackedInt32Array) :
	#create a new int array
	vals = []
	#fill it with the info from the packed int array
	for i in range(new_vals.size()):
		vals.append(new_vals[i])
	#set the shader param to the new vals
	material.set_shader_parameter("vals", vals)
