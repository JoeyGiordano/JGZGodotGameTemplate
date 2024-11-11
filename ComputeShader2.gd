extends Node2D
class_name ComputeShader2

#from: https://www.youtube.com/watch?v=OR3eJxrgdAw&ab_channel=DitzyNinja%27sGodojo

var start_vals := PackedInt32Array([0,1,0,1, 0,1,1,1, 1,1,1,0, 1,1,0,0])

func _ready():
	var rendering_device := RenderingServer.create_local_rendering_device()
	
	# Load and create the shader
	var shader_file = load("res://compute.glsl")
	var shader_spirv = shader_file.get_spirv()
	var shader_RID := rendering_device.shader_create_from_spirv(shader_spirv)
	
	#uniform 1
	var in_ints := PackedInt32Array([0,1,0,1, 0,1,1,1, 1,1,1,0, 1,1,0,0]).to_byte_array()
	var storage_buffer_RID1 = rendering_device.storage_buffer_create(in_ints.size(), in_ints)
	var uniform1 := RDUniform.new()
	uniform1.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform1.binding = 0
	uniform1.add_id(storage_buffer_RID1)
	
	#uniform 2
	var out_ints := PackedInt32Array([0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0]).to_byte_array()
	var storage_buffer_RID2 = rendering_device.storage_buffer_create(out_ints.size(), out_ints)
	var uniform2 := RDUniform.new()
	uniform2.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform2.binding = 1
	uniform2.add_id(storage_buffer_RID2)
	
	#create uniform set
	var uniform_set_RID := rendering_device.uniform_set_create([uniform1,uniform2], shader_RID, 0)
	
	var pipeline_RID := rendering_device.compute_pipeline_create(shader_RID)
	
	var compute_list_id := rendering_device.compute_list_begin()
	
	rendering_device.compute_list_bind_compute_pipeline(compute_list_id, pipeline_RID)
	rendering_device.compute_list_bind_uniform_set(compute_list_id, uniform_set_RID, 0)
	rendering_device.compute_list_dispatch(compute_list_id, 1, 1, 1) #WORK GROUPS
	rendering_device.compute_list_end()
	
	rendering_device.submit()
	rendering_device.sync()
	
	var output_bytes := rendering_device.buffer_get_data(storage_buffer_RID2)
	var output := output_bytes.to_int32_array()
	print(output)
