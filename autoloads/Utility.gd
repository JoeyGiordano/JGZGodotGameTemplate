extends Node

### AUTOLOAD

### Utility ###
## Stores general use or bulky methods for use in other scripts.

func replace_scene_in_holder(holder_node : Node, new_scene : PackedScene) :
	# replace the scene in the holder_node (ShellSceneHolder, LevelHolder, etc) with a newly instantiated scene from PackedScene new_scene
	# holder_node should only hold one node at a time
	# use Reference to get scenes (and sometimes holders) instead of loading them yourself!
	remove_scene_in_holder(holder_node)
	var s = new_scene.instantiate()
	holder_node.add_child(s)
	# purposely don't return s. The user of this function should instead access it from the holder_node, for clarity and consistency

func remove_scene_in_holder(holder_node : Node) :
	match holder_node.get_child_count() :
		0 : pass
		1 : 
			holder_node.get_child(0).queue_free()
			holder_node.remove_child(holder_node.get_child(0))
		_ : print("Utility.replace_scene_in_holder() used on holder node " + holder_node.name + " with more than one child. " + holder_node.name + " had " + str(holder_node.get_child_count) + " children." )
