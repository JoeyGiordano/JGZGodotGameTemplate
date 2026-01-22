extends Node2D
class_name LaikaAIv1

@onready var tank : Tank = get_parent()

#tanks are designed to be easily controlled by code (see Tank script under ##INPUT for methods to call)
#all you have to do is add this node as a child of a tank (we might have to change this)

#right now he just goes in circles

func _process(delta):
	tank.set_move_input_x(-1)
	tank.set_move_input_y(-1)
