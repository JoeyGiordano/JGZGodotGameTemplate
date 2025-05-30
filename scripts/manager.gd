extends Node
class_name Manager

###### LIST OF VARIABLES ######

var is_jerry_alive : bool = true
var jerrys_health : int = 0

#### END LIST OF VARIABLES ####

#nothing to see here

###### LIST OF FUNCTIONS ######

func jerry_is_dead() :
	print("he's dead")

func wait_jerrys_alive(health : int) :
	print("wait, Jerry's alive and he has " + str(health) + " remaining" )




#### END LIST OF FUNCTIONS ####


# Resource function, please do not touch
func switch_to_scene(scene_path : String) :
	#needs to use the full path name like "res://folder/subfolder/etc/titlescene.tscn"
	GameContainer.GC.switch_to_scene(scene_path)
