extends Node
class_name EffectsHandler

@onready var tank : Tank = get_parent()

var on_fire : bool = false
var frozen : bool = false
var electrified : bool = false


func _process(_delta) :
	
	on_fire = Input.is_key_pressed(KEY_F)
	frozen = Input.is_key_pressed(KEY_G)
	electrified = Input.is_key_pressed(KEY_H)
