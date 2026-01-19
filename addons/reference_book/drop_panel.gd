@tool
extends MenuButton

signal path_received(path)

func _can_drop_data(_pos, data) -> bool:
	return data is Dictionary and data.has("files")

func _drop_data(_pos, data):
	for path in data["files"]:
		path_received.emit(path)
