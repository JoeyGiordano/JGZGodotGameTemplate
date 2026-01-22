extends Node
class_name _TankManager

### AUTOLOAD

### TankManager ###
## Provides methods for getting, creating, and destroying tanks. Manages tank IDs.
## Provides methods for calling the same function on groups of tanks.

var next_id : int = 0

## Get

func get_tank(tank_id : int) -> Tank :
	for t : Tank in Global.PlayerTanks.get_children() :
		if t.id == tank_id :
			return t
	for t : Tank in Global.NpcTanks.get_children() :
		if t.id == tank_id :
			return t
	return null

func get_player_tanks() -> Array[Tank] :
	var a : Array[Tank]
	a.assign(Global.PlayerTanks.get_children())
	return a

func get_npc_tanks() -> Array[Tank] :
	var a : Array[Tank]
	a.assign(Global.NpcTanks.get_children())
	return a

func get_all_tanks() -> Array[Tank] :
	var a : Array[Tank]
	a.append_array(get_player_tanks())
	a.append_array(get_npc_tanks())
	return a

## Create

func create_player_tank(p : PlayerProfile) -> Tank :
	var t : Tank = _create_tank(Global.PlayerTanks, p)
	p.associate(t.id)
	return t

func create_npc_tank(p : TankProfile, associate : bool = false) :
	var t : Tank = _create_tank(Global.NpcTanks, p)
	if associate :
		p.associate(t.id)
	return t

func _create_tank(parent : Node, profile : TankProfile = TankProfile.new(), starting_stats : StatBoost = Ref.base_tank_stats) -> Tank :
	var t : Tank = Ref.tank_scene.instantiate()
	# NOTE _init() is called during the execution of the previous line
	#set id
	t.id = next_id
	next_id += 1
	#set profile and stats
	t.profile = profile
	t.stats = starting_stats.copy()
	#add the new tank to the scene tree
	parent.add_child(t)
	# NOTE _ready() is called during the execution of the previous line (first on all the children of the tank, then on the tank)
	return t

# Destroy

func destroy_tank_from_id(tank_id : int) :
	var t : Tank = get_tank(tank_id)
	destroy_tank(t)

func destroy_all_tanks() :
	for i in range(Global.PlayerTanks.get_children().size() - 1, -1, -1) :
		destroy_tank(Global.PlayerTanks.get_children()[i])

func destroy_tank(t : Tank) :
	t.profile.dissociate()
	t.queue_free()

## CALL ALL
## Use these functions to call a tank method on multiple tanks at once

func call_func_on_all_tanks(func_name : String, args : Array = []) :
	call_func_on_list_of_tanks(get_all_tanks(), func_name, args)

func call_func_on_player_tanks(func_name : String, args : Array = []) :
	call_func_on_list_of_tanks(get_player_tanks(), func_name, args)

func call_func_on_npc_tanks(func_name : String, args : Array = []) :
	call_func_on_list_of_tanks(get_npc_tanks(), func_name, args)

func call_func_on_list_of_tanks(tanks : Array[Tank], func_name : String, args : Array = []) :
	for i in range(tanks.size() - 1, -1, -1) : #go backwards through the list in case some destructive method is being called
		tanks[i].callv(func_name, args)
