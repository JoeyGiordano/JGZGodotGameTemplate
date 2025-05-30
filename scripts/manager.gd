extends Node
class_name Manager

###### LIST OF VARIABLES ######

var did_jerry_pick_up_the_potion : bool = false

#### END LIST OF VARIABLES ####

#nothing to see here

###### LIST OF FUNCTIONS ######

func jerry_picked_up_the_potion() :
	
	pass

func jerry_got_killed_by_the_monster() :
	
	pass


#### END LIST OF FUNCTIONS ####


# Resource function, please do not touch
func switch_to_scene(scene_path : String) :
	#needs to use the path name without "res://" and ".tscn" like "folder/subfolder/etc/titlescene"
	switch_to_scene_full_path("res://" + scene_path + ".tscn")
	pass

func switch_to_scene_full_path(scene_path : String) :
	#needs to use the full path name like "res://folder/subfolder/etc/titlescene.tscn"
	GameContainer.GC.switch_to_scene(scene_path)
	pass
