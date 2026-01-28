@tool
extends EditorPlugin

const window_scene: PackedScene = preload("./path_manager/path_manager_menu.tscn")
var dock : EditorDock
var window : Window
var dock_content

func _enable_plugin() -> void:
	pass

func _disable_plugin() -> void:
	pass


func _enter_tree() -> void:
	dock = EditorDock.new()
	dock.title = "Ref Book"
	dock.default_slot = EditorDock.DOCK_SLOT_BOTTOM
	dock.available_layouts = EditorDock.DOCK_LAYOUT_ALL
	dock_content = preload("res://addons/reference_book/Control.tscn").instantiate()
	dock.add_child(dock_content)
	add_dock(dock)
	
	# path manager
	add_tool_menu_item("Reference Book...", create_window)

func _exit_tree() -> void:
	remove_dock(dock)
	dock.queue_free()
	dock = null
	
	#path manager
	remove_tool_menu_item("Reference Book...")

# for path manager
func create_window() -> void:
	window = window_scene.instantiate()
	EditorInterface.get_base_control().add_child(window)
	window.dock_content = dock_content
	window.init()
	
