@tool
extends HBoxContainer

var file_dialog := EditorFileDialog.new()
var previewer := EditorInterface.get_resource_previewer()

var target_res : Resource

func _ready() -> void:
	#signal connections
	$LoadButton.pressed.connect(_on_load_pressed)
	$ResDrop.get_popup().id_pressed.connect(_on_res_load_dropdown_id_pressed)
	$ResetButton.pressed.connect(_on_reset_pressed)
	$ResDrop.path_received.connect(_handle_path)
	#file dialog setup
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	#file_dialog.filters = PackedStringArray(["*.tscn ; Scene files"])
	file_dialog.title = "Select Resource"
	file_dialog.file_selected.connect(_handle_path)
	add_child(file_dialog)

func _on_load_pressed() :
	file_dialog.popup_centered_ratio(0.6)

func _on_res_load_dropdown_id_pressed(id : int) :
	match id :
		0 : file_dialog.popup_centered_ratio(0.6)

func _on_reset_pressed() :
	target_res = null
	$ResDrop/Button/Label.show()
	$ResetButton.hide()
	$ResDrop/AspRatioBox/PreviewTextRect.texture = null

func _handle_path(path: String) :
	var res := ResourceLoader.load(path)
	if res:
		target_res = res
		$ResDrop/Button/Label.hide()
		$ResetButton.show()
		previewer.queue_resource_preview(path, self, "_on_preview_ready", res)

func _on_preview_ready(path, preview_texture, preview_thumbnail_texture, userdata):
	$ResDrop/AspRatioBox/PreviewTextRect.texture = preview_texture
