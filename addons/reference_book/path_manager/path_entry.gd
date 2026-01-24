@tool
extends PanelContainer

func _ready() -> void:
	$MarginContainer/HBoxContainer/Button.pressed.connect(_on_pressed)

func set_text(text : String) :
	$MarginContainer/HBoxContainer/PathLabel.text = text

func _on_pressed() :
	get_viewport().remove_path($MarginContainer/HBoxContainer/PathLabel.text)
	queue_free()
