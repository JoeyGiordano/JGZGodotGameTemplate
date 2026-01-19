@tool
extends Control

#NOTE Ctrl click the uid link to view the resource in the inspector.
#NOTE Alternatively, hover your mouse over the uid and press Open or Show in File System

var undo : EditorUndoRedoManager

@onready var loader = $HBox/ResourceLoaderUI
@onready var settings = $HBox/ResourceEntrySettings

func _ready() -> void:
	# signal connections
	loader.resource_loaded.connect(_on_resource_loaded)
	loader.resource_cleared.connect(_on_resource_cleared)
	settings.add_pressed.connect(_on_add_pressed)
	
	# undo redo
	undo = EditorPlugin.new().get_undo_redo()

func _on_resource_loaded(res : Resource) :
	settings._on_resource_loaded(res)
	
func _on_resource_cleared() :
	settings._on_resource_cleared()

func _on_add_pressed(line : String) :
	var path := "res://autoloads/Reference/Reference.gd"
	var lines_to_insert := [ line ]
	var result = insert_lines(path, "@export_group(\"Shell Scenes\")", lines_to_insert)
	if result :
		settings.send_message("Resource " + settings.target_res.resource_name + " added!", 5)
		settings.reset()
		loader._reset_resource()
	

#region Backend

func insert_lines(path : String, line_to_insert_at : String, lines_to_insert := []) -> bool :
	# example lines_to_insert: lines_to_insert = [ "var x : int = 0", "var y : String = \"test\"", "var z : int = 10" ]
	
	# access the script file text
	if not FileAccess.file_exists(path):
		push_error("Script not found: " + path)
		return false
	
	var file := FileAccess.open(path, FileAccess.READ)
	var text := file.get_as_text()
	file.close()
	
	# prevent vars that already exist in the script from being duplicated
	for line in lines_to_insert:
		var just_var_and_var_name_part = "var " + line.substr(line.find("var ") + 4).get_slice(" ", 0)
		if text.find(just_var_and_var_name_part) != -1:
			settings.send_message("A variable with that name already exists!", 5)
			return false
	
	# parse the script file text and insert the lines at the desired position
	var insert_index = -1
	var lines := text.split("\n")
	for i in range(lines.size()) :
		if lines[i] == line_to_insert_at :
			insert_index = i+1
	if insert_index == -1 :
		push_error("Insertion line not found: " + line_to_insert_at)
		insert_index = 0
	
	var new_lines := lines.duplicate()
	for i in range(lines_to_insert.size()):
		new_lines.insert(insert_index + i, lines_to_insert[i])
	
	var new_text := "\n".join(new_lines)
	
	# call _write_script undo redo safe to overwrite the file
	undo.create_action("Insert vars into script")
	undo.add_do_method(self, "_write_script", path, new_text)
	undo.add_undo_method(self, "_write_script", path, text)
	undo.commit_action()
	
	# pull up the script
	var script := load(path) as Script
	EditorInterface.edit_script(script)
	
	return true

func _write_script(path: String, text: String):
	# gaurentee the script is closed
	var script := load(path) as Script
	var script_editor := EditorInterface.get_script_editor()
	if not script :
		push_error("Script failed to load. Path: " + path)
		return
	if not script_editor :
		push_error("Script editor failed to load.")
		return
	
	#region Option 1
	# the idea behind this is to virtually open and modify the scripts text in the script editor
	# the new text is not automatically saved
	
	# open the script
	#EditorInterface.edit_script(script, 9)
	# replace the text
	#script_editor.get_current_editor().get_base_editor().text = text
	
	#endregion
	
	#region Option 2
	
	# the idea behind this is to overwrite the script objects source code variable directly and then re save the script
	# this only works when the script is not open in the script editor so this opens the script and then closes it in the editor to ensure that the script is closed
	# the problem is that there is no simple way to close the script, so I pass a key input event (CTRL+W) to the script editor viewport to close the currently open tab
	# to do this I use push_unhandled_input() which is  DEPRECATED function
	# I would use push_input() but it propagates the input event through other calls before propagating to _shortcut_input() and something in the editor scene tree absorbs the event
	# I tried *many* ways to avoid using the deprecated method but its the only option
	
	# open the script
	EditorInterface.edit_script(script)
	
	# close the script
	# create the key event
	var event = InputEventKey.new()
	event.keycode = KEY_W
	event.meta_pressed = true
	event.pressed = true
	# propagate the key event
	EditorInterface.get_script_editor().get_viewport().push_unhandled_input(event) #DEPRECATED function
	
	# overwrite the source code
	# this works but only if the script is not open in the script editor
	script.source_code = text
	ResourceSaver.save(script)
	
	#endregion
	
	#region Graveyard
	
	#if script_editor.get_open_scripts().has(script) :
		#print("script must be closed")
		#return
	
	# write the new text to script file
	#var file := FileAccess.open(path, FileAccess.WRITE)
	#file.store_string(text)
	#file.close()
	
	
	#EditorInterface.get_base_control().get_viewport().push_input(event)
	#EditorInterface.get_command_palette().execute("script_editor/close_tab") #not real
	#script_editor.get_current_editor().get_base_editor().get_viewport().push_input(event)
	#script_editor.get_current_editor().get_base_editor().input
	
	#script_editor.editor_script_changed.emit(script)
	
	# reload the script
	#script = load(path)
	#if script :
		#script.reload(true)
		#script.reload(false)
	
	#endregion


#endregion
