extends Node2D
class_name ComputeShader

var start_vals := PackedInt32Array([0,1,0,1, 0,1,1,1, 1,1,1,0, 1,1,0,0])
var rendering_device : RenderingDevice
var shader_RID : RID
var storage_buffer_RID1 : RID
var storage_buffer_RID2 : RID
var uniform_set_RID : RID
var pipeline_RID : RID
var compute_list_id


func _ready():
	rendering_device = RenderingServer.create_local_rendering_device()
	
	# Load and create the shader
	var shader_file = load("res://compute.glsl")
	var shader_spirv = shader_file.get_spirv()
	shader_RID = rendering_device.shader_create_from_spirv(shader_spirv)
	
	# Create storage buffers for input and output
	var input1 := start_vals.to_byte_array()
	storage_buffer_RID1 = rendering_device.storage_buffer_create(input1.size(), input1)
	
	var output1 = PackedInt32Array([0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0]).to_byte_array()  # Initialize output with zeros
	storage_buffer_RID2 = rendering_device.storage_buffer_create(output1.size(), output1)
	
	# Bind storage buffers to the shader as uniforms
	var uniform1 := RDUniform.new()
	uniform1.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform1.binding = 0
	uniform1.add_id(storage_buffer_RID1)
	
	var uniform2 := RDUniform.new()
	uniform2.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform2.binding = 1
	uniform2.add_id(storage_buffer_RID2)
	
	# Create uniform set
	uniform_set_RID = rendering_device.uniform_set_create([uniform1,uniform2], shader_RID, 0)
	
	# Create pipeline
	pipeline_RID = rendering_device.compute_pipeline_create(shader_RID)

func set_inputs(input1_pack : PackedInt32Array) :
	# Update input data
	var input1 = input1_pack.to_byte_array()
	rendering_device.buffer_update(storage_buffer_RID1, 0, input1.size(), input1)
	
func submit() :
	# Begin the compute list and bind pipeline and uniforms for dispatch
	compute_list_id = rendering_device.compute_list_begin()
	rendering_device.compute_list_bind_compute_pipeline(compute_list_id, pipeline_RID)
	rendering_device.compute_list_bind_uniform_set(compute_list_id, uniform_set_RID, 0)
	rendering_device.compute_list_dispatch(compute_list_id, 1, 1, 1) #WORK GROUPS
	rendering_device.compute_list_end()
	# Submit the computation
	rendering_device.submit()
	
func sync_and_get_output() -> PackedInt32Array :
	# Sync with the GPU
	rendering_device.sync()
	# Get and return output from the shader
	var output_bytes := rendering_device.buffer_get_data(storage_buffer_RID2)
	var output := output_bytes.to_int32_array()
	return output
