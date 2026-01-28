extends Object
class_name DoubleDict

# Basically just Dictionary[int, Dictionary[int, Variant]]
# Godot does not support this with explicity typing normally

var data = {}

## Sets the entry at (x,y). If there is no entry, this creates an entry. If there is already an entry, this overwrites it.
func set_entry(x: int, y: int, obj: Variant):
	if !_has_col(x) :
		data.set(x,{})
	data[x].set(y,obj)

## See set_entry().
func set_entryv(coords: Vector2i, obj: Variant):
	set_entry(coords.x,coords.y,obj)

## Returns the value at (x,y). If there is no entry for (x,y), returns default. An error will be printed if default is left null and there is no entry.
func get_entry(x: int, y: int, default: Variant = null) -> Variant:
	var do_print = true if default == null else false
	if has_entry(x,y,do_print) :
		return data[x][y]
	return default

## See get_entry().
func get_entryv(coords: Vector2i, default: Variant = null) -> Variant:
	return get_entry(coords.x,coords.y,default)

## Deletes the entry at (x,y) and performs associated cleanup.
func delete_entry(x: int, y: int, do_print: bool = false):
	if !has_entry(x,y,do_print) :
		if do_print: push_warning("Attempted to delete non-existant entry in col x=%s, y=%s." % [x,y])
		return
	data[x].erase(y)
	# If the subdict is now empty, delete it
	if data[x].size == 0:
		data.erase(x)

## See delete_entry().
func delete_entryv(coords: Vector2i, do_print: bool = false):
	delete_entry(coords.x,coords.y,do_print)

func _has_col(x: int, do_print: bool = false) -> bool:
	if data.has(x):
		return true
	if do_print: push_error("Column x=%s not found." % [x])
	return false

func has_entry(x: int, y: int, do_print: bool = false) -> bool :
	if !_has_col(x,do_print) :
		return false
	if data[x].has(y) :
		return true
	if do_print: push_error("Entry not found: no row y=%s in col x=%s." % [y,x])
	return false

func has_entryv(coords: Vector2i, do_print: bool = false) -> bool :
	return has_entry(coords.x,coords.y,do_print)
