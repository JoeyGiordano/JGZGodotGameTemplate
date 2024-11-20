extends Sprite2D
class_name GolRect

@onready var topLeft : Node2D = $TopLeft
@onready var bottomRight : Node2D = $BottomRight

var field_vals : Array[float]

func set_dims(dims : PackedInt32Array):
	material.set_shader_parameter("width", float(dims[0]))
	material.set_shader_parameter("height", float(dims[1]))

func set_field(new_field_vals : PackedFloat32Array) :
	#create a new int array
	field_vals = []
	#fill it with the info from the packed int array
	for i in range(new_field_vals.size()):
		field_vals.append(new_field_vals[i])
	#set the shader param to the new vals
	material.set_shader_parameter("vals", field_vals)
