extends Node2D
class_name Item

@export var item_res : ItemResource

@onready var hitbox : Area2D = $Hitbox

var t : Tank

func _ready():
	hitbox.area_entered.connect(on_area_entered)
	hitbox.get_child(0).modulate = item_res.color

func get_stats() -> StatBoost :
	return item_res.get_stats()

func on_area_entered(area : Area2D) :
	if area.is_in_group("tank_hitbox") :
		var tank : Tank = area.get_parent().tank_rigidbody.tank #all tank hitboxes must be direct children of a tank loadout
		get_pickedup_by(tank)
		
func get_pickedup_by(tank : Tank) :
	#need to use call_deferred because the tank can't reparent item during physics_process
	#something else interesting I learned while debugging this code is that when reparent is called, the node exits and reenters the scene tree
	#the engine considers reentering the scene tree as a way of entering into an area, so if you reparent an area that was already entered another area, on_area_entered will get called again
	#it didn't end up being useful with what ended up here in what we ended up with but I thought I'd share the tip and possibly save you a few debugging hours if you ever encounter that problem
	call_deferred("_get_pickedup_by", tank)

func _get_pickedup_by(tank : Tank) :
	hitbox.monitoring = false
	hitbox.monitorable = false
	hide()
	reparent(tank.items)
	tank.stats_handler.add_boost_with_source(item_res.stat_boost, self)
