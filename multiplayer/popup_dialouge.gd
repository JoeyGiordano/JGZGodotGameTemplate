extends Node

# project settings -> window (advanced options) -> embed subwindows = false

func create_popup(title : String, width : int, height : int , message : String) :
	var popup := Window.new()
	popup.title = title
	popup.size = Vector2(width, height)
	popup.close_requested.connect(popup.queue_free) #closes when x button pressed

	var label := Label.new()
	label.text = message
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.anchor_left = 0
	label.anchor_top = 0
	label.anchor_right = 1
	label.anchor_bottom = 1
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	popup.add_child(label)
	add_child(popup)
	popup.popup_centered()
