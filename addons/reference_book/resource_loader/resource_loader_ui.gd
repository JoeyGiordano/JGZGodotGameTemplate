@tool
extends HBoxContainer

signal resource_loaded(res)
signal resource_cleared

var undo : EditorUndoRedoManager
var file_dialog := EditorFileDialog.new()
var previewer := EditorInterface.get_resource_previewer()

var target_res : Resource

func _ready() -> void:
	# signal connections
	$LoadButton.pressed.connect(_on_load_pressed)
	$ResDrop.get_popup().id_pressed.connect(_on_res_load_dropdown_id_pressed)
	$ResetButton.pressed.connect(_on_reset_pressed)
	$ResDrop.path_received.connect(_handle_path)
	
	# file dialog setup
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	#file_dialog.filters = PackedStringArray(["*.tscn ; Scene files"])
	file_dialog.title = "Select Resource"
	file_dialog.file_selected.connect(_handle_path)
	add_child(file_dialog)
	
	# undo redo
	undo = EditorPlugin.new().get_undo_redo()

func _on_load_pressed() :
	file_dialog.popup_centered_ratio(0.6)

func _on_res_load_dropdown_id_pressed(id : int) :
	match id :
		0 : file_dialog.popup_centered_ratio(0.6)

func _on_reset_pressed() :
	if not target_res : return
	
	undo.create_action("Reset Resource")
	undo.add_do_method(self, "_reset_resource")
	undo.add_undo_method(self, "_set_res_from_path", target_res.resource_path)
	undo.commit_action()

func _handle_path(path : String) :
	if not target_res :
		undo.create_action("Set Resource")
		undo.add_do_method(self, "_set_res_from_path", path)
		undo.add_undo_method(self, "_reset_resource")
		undo.commit_action()
	else :
		undo.create_action("Change Resource")
		undo.add_do_method(self, "_set_res_from_path", path)
		undo.add_undo_method(self, "_set_res_from_path", target_res.resource_path)
		undo.commit_action()

func _reset_resource() :
	target_res = null
	$ResDrop/Button/Label.show()
	$ResetButton.hide()
	$ResDrop/AspRatioBox/PreviewTextRect.texture = null
	resource_cleared.emit()
	$ResDrop/Button/TextureName.text = ""

func _set_res_from_path(path: String) :
	var res := ResourceLoader.load(path)
	if res:
		target_res = res
		$ResDrop/Button/Label.hide()
		$ResetButton.show()
		previewer.queue_resource_preview(path, self, "_on_preview_ready", res)
		res.resource_name = res.resource_path.get_basename().get_file()
		resource_loaded.emit(res)

func _on_preview_ready(path, preview_texture, preview_thumbnail_texture, userdata):
	if preview_texture :
		$ResDrop/AspRatioBox/PreviewTextRect.texture = preview_texture
	else :
		$ResDrop/Button/TextureName.text = target_res.resource_name
