extends Node2D
class_name ComputeShader

var dims : PackedInt32Array
var rendering_device : RenderingDevice
var shader_RID : RID
var storage_buffer_RID0 : RID
var storage_buffer_RID1 : RID
var storage_buffer_RID2 : RID
var storage_buffer_RID3 : RID
var storage_buffer_RID4 : RID
var uniform_set_RID : RID
var pipeline_RID : RID
var compute_list_id

## OUTPUT ACCESS
var field1_OUT : PackedFloat32Array
var field2_OUT : PackedFloat32Array

func setup_compute_shader(dimensions : PackedInt32Array):
	dims = dimensions
	
	# Create rendering device
	rendering_device = RenderingServer.create_local_rendering_device()
	
	# Load and create the shader
	var shader_file = load("res://compute.glsl")
	var shader_spirv = shader_file.get_spirv()
	shader_RID = rendering_device.shader_create_from_spirv(shader_spirv)
	
	# Create storage buffers for input and output
	var dims_bytes := dims.to_byte_array()
	storage_buffer_RID0 = rendering_device.storage_buffer_create(dims_bytes.size(), dims_bytes)
	
	var field1in := create_empty().to_byte_array()
	storage_buffer_RID1 = rendering_device.storage_buffer_create(field1in.size(), field1in)
	
	var field1out = create_empty().to_byte_array()  # Initialize output with zeros
	storage_buffer_RID2 = rendering_device.storage_buffer_create(field1out.size(), field1out)
	
	var field2in := create_empty().to_byte_array()
	storage_buffer_RID3 = rendering_device.storage_buffer_create(field2in.size(), field2in)
	
	var field2out = create_empty().to_byte_array()  # Initialize output with zeros
	storage_buffer_RID4 = rendering_device.storage_buffer_create(field2out.size(), field2out)
	
	# Bind storage buffers to the shader as uniforms
	var uniform0 := RDUniform.new()
	uniform0.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform0.binding = 0
	uniform0.add_id(storage_buffer_RID0)
	
	var uniform1 := RDUniform.new()
	uniform1.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform1.binding = 1
	uniform1.add_id(storage_buffer_RID1)
	
	var uniform2 := RDUniform.new()
	uniform2.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform2.binding = 2
	uniform2.add_id(storage_buffer_RID2)
	
	var uniform3 := RDUniform.new()
	uniform3.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform3.binding = 3
	uniform3.add_id(storage_buffer_RID3)
	
	var uniform4 := RDUniform.new()
	uniform4.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform4.binding = 4
	uniform4.add_id(storage_buffer_RID4)
	
	# Create uniform set
	uniform_set_RID = rendering_device.uniform_set_create([uniform0,uniform1,uniform2,uniform3,uniform4], shader_RID, 0)
	
	# Create pipeline
	pipeline_RID = rendering_device.compute_pipeline_create(shader_RID)

func create_empty() -> PackedFloat32Array:
	var temp : Array[float] = []
	temp.resize(dims[0] * dims[1])
	temp.fill(0)
	return PackedFloat32Array(temp)

func set_inputs(field1in_new : PackedFloat32Array, field2in_new) :
	# Update input data
	var field1in_new_bytes = field1in_new.to_byte_array()
	rendering_device.buffer_update(storage_buffer_RID1, 0, field1in_new_bytes.size(), field1in_new_bytes)
	var field2in_new_bytes = field2in_new.to_byte_array()
	rendering_device.buffer_update(storage_buffer_RID3, 0, field2in_new_bytes.size(), field2in_new_bytes)
	
func submit() :
	# Begin the compute list and bind pipeline and uniforms for dispatch
	compute_list_id = rendering_device.compute_list_begin()
	rendering_device.compute_list_bind_compute_pipeline(compute_list_id, pipeline_RID)
	rendering_device.compute_list_bind_uniform_set(compute_list_id, uniform_set_RID, 0)
	rendering_device.compute_list_dispatch(compute_list_id, dims[0]*dims[1]/16, 1, 1) #WORK GROUPS
	rendering_device.compute_list_end()
	# Submit the computation
	rendering_device.submit()
	
func sync() :
	# Sync with the GPU
	rendering_device.sync()
	# Get and return output from the shader
	var field1out_bytes := rendering_device.buffer_get_data(storage_buffer_RID2)
	field1_OUT = field1out_bytes.to_float32_array()
	var field2out_bytes := rendering_device.buffer_get_data(storage_buffer_RID4)
	field2_OUT = field2out_bytes.to_float32_array()
