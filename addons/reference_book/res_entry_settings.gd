@tool
extends VBoxContainer

signal add_pressed(line : String)

var target_res : Resource
var target_res_uid : String
var export : bool = false
var use_preload : bool = false
var override_name : String = ""

@onready var message := $Message

func _ready() -> void:
	$Grid/ExportCheckBox.pressed.connect(_on_export_pressed)
	$Grid/PreloadCheckBox.pressed.connect(_on_preload_pressed)
	$Grid/NameLineEdit.text_changed.connect(_on_name_edited)
	$AddButton.pressed.connect(_on_add_pressed)

func _on_resource_loaded(res : Resource) :
	target_res = res
	target_res_uid = _get_uid(res.resource_path)
	$Grid/NameLineEdit.placeholder_text = res.resource_name
	$AddButton.disabled = false
	_update_preview()

func _on_resource_cleared() :
	reset()

func _on_export_pressed() :
	export = !export
	_update_preview()

func _on_preload_pressed() :
	use_preload = !use_preload
	_update_preview()

func _on_add_pressed() :
	add_pressed.emit(_convert_to_line())

func _on_name_edited(text) :
	override_name = $Grid/NameLineEdit.text
	_update_preview()

func _update_preview() :
	$Preview.text = _convert_to_line()

func _convert_to_line() -> String :
	if !target_res : return ""
	var _export = "@export " if export else ""
	var _name = override_name if override_name else target_res.resource_name
	var line = "%svar %s : " % [_export,_name]
	
	var _uid = "\"" + target_res_uid + "\""
	if use_preload :
		var _type = target_res.get_class()
		line = line + "%s = preload(%s)" % [_type,_uid]
	else :
		line = line + "String = " + _uid
	
	return line

func _get_uid(path : String) -> String :
	#ResourceLoader.get_resource_uid(target_res.resource_path) # this doesn't give the right uid
	#select the file in the editor
	EditorInterface.get_file_system_dock().navigate_to_path(path)
	
	#simulate a keyboard shortcut
	var event = InputEventKey.new()
	event.keycode = KEY_C
	event.meta_pressed = true
	event.shift_pressed = true
	event.alt_pressed = true
	event.pressed = true
	
	EditorInterface.get_file_system_dock().get_viewport().push_input(event)
	
	return DisplayServer.clipboard_get() #this is honestly ridiculous

func send_message(text : String, time : float) :
	message.text = text
	await get_tree().create_timer(time).timeout
	if message.text == text :
		message.text = ""

func reset() :
	$Grid/NameLineEdit.placeholder_text = ""
	$Grid/NameLineEdit.text = ""
	$Preview.text = ""
	target_res = null
	target_res_uid = ""
	$AddButton.disabled = true
