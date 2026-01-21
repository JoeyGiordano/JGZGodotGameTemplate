@tool
extends Window

var paths : Array[String] = []

var toolbar
var path_option : OptionButton

@onready var lineedit := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/LineEdit
@onready var button := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Button
@onready var path_entry_scene : PackedScene = preload("res://addons/reference_book/path_manager/path_entry.tscn")

func _ready() -> void:
	close_requested.connect(_on_close_requested)
	button.pressed.connect(_on_add_pressed)
	lineedit.text_changed.connect(_on_text_changed)

func init() :
	path_option = toolbar.path_option
	
	lineedit.text = "res://autoloads/Reference/Reference.gd"
	_on_add_pressed()
	_on_text_changed("")

func _on_close_requested() :
	hide()

func _on_add_pressed() :
	var p = path_entry_scene.instantiate()
	$PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/PathList.add_child(p)
	var text = lineedit.text
	p.set_text(text)
	paths.append(text)
	lineedit.text = ""
	update_paths_button()

func _on_text_changed(text) :
	if lineedit.text == "" :
		button.disabled = true
	else :
		button.disabled = false

func remove_path(path : String) :
	paths.erase(path)
	update_paths_button()

func update_paths_button() :
	path_option.clear()
	for path in paths : 
		path_option.add_item(path)
