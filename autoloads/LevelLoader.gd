extends Node
class_name _LevelLoader

### AUTOLOAD

### LevelLoader ###
## Loads levels and spawns players.

func remove_level() :
	Utility.remove_scene_in_holder(Global.LevelHolder) # the level manager is on the level node

func next_level() :
	switch_level(_determine_next_level())

func switch_level(level_name : String) :
	_switch_level(Ref.get(level_name))

func _switch_level(new_level : PackedScene) :
	#replace the scene in the LevelHolder with a newly instantiated scene from PackedScene new_level
	#use Reference to get scenes instead of loading them yourself!
	Utility.replace_scene_in_holder(Global.LevelHolder, new_level)

func _determine_next_level() -> String :
	return "test_level_" + str(randi_range(0,3))

func spawn_players() :
	#spawns players, can be overriden in extended class if more complex behavior is desired
	var num_players = PlayerManager.player_count()
	var spawn_points : Array = Global.CurrentLevel().get_node("SpawnPoints").get_children()
	#check if theres enough spawn points
	assert(num_players <= spawn_points.size(), "Not enough spawn points available in level " + Global.CurrentLevel().name + ". There were " + str(num_players) + " tanks and only " + str(spawn_points.size()) + " spawn points.")
	#spawn players at points randomly
	var p : Array = spawn_points.duplicate()
	p.shuffle() #shuffle the array
	for i in num_players :
		#put at spawn point
		PlayerManager.get_associated_tank(i).respawn(p.get(i).position)
		#randomize rotation
		PlayerManager.get_associated_tank(i).tank_rigidbody.rotation = randf_range(0,360)
		#PlayerManager.get_associated_tank(i).tank_rigidbody.rotation = p.get(i).rotation #could use spawn point rotation instead
