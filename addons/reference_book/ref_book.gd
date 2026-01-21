@tool
extends EditorPlugin

const window_scene: PackedScene = preload("./path_manager/path_manager_menu.tscn")
var toolbar
var window : Window

func _enable_plugin() -> void:
	pass

func _disable_plugin() -> void:
	pass


func _enter_tree() -> void:
	toolbar = preload("res://addons/reference_book/Control.tscn").instantiate()
	
	#add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, toolbar)
	#add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BL, toolbar)
	add_control_to_bottom_panel(toolbar, "Ref Book")
	
	# path manager
	add_tool_menu_item("Reference Book...", create_window)

func _exit_tree() -> void:
	#remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, toolbar)
	#remove_control_from_docks(toolbar)
	remove_control_from_bottom_panel(toolbar)
	toolbar.free()
	
	#path manager
	remove_tool_menu_item("Reference Book...")

# for path manager
func create_window() -> void:
	window = window_scene.instantiate()
	EditorInterface.get_base_control().add_child(window)
	window.toolbar = toolbar
	window.init()
	
