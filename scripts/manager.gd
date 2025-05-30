extends Node
class_name Manager

###### LIST OF VARIABLES ######



#### END LIST OF VARIABLES ####

func switch_to_scene(scene_path : String) :
	#needs to use the full path name like "res://folder/subfolder/etc/titlescene.tscn"
	GameContainer.GC.switch_to_scene(scene_path)

###### LIST OF FUNCTIONS ######

func jerry_is_dead() :
	print("he's dead")





#### END LIST OF FUNCTIONS ####
