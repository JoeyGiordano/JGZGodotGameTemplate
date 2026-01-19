@tool
extends EditorPlugin

var toolbar

func _enable_plugin() -> void:
	pass

func _disable_plugin() -> void:
	pass


func _enter_tree() -> void:
	toolbar = preload("res://addons/reference_book/Control.tscn").instantiate()
	
	#add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, toolbar)
	add_control_to_bottom_panel(toolbar, "Ref Book")

func _exit_tree() -> void:
	#remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, toolbar)
	remove_control_from_bottom_panel(toolbar)
	
	toolbar.free()
