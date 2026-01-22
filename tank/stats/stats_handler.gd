extends Node
class_name StatsHandler

### StatsHandler ###
## Handles all stats for one tank. This script is on a node that is a direct child of a tank.
## Use this script by calling one of the three add or remove boost methods.

@onready var tank : Tank = get_parent()
@onready var unconditional_stats : StatBoost #player starting base stats + non-reactive stats from stat boosts (updated when a new stat boost is added)

var boost_list : Array[BoostHolder]

func _ready() :
	unconditional_stats = tank.stats #when everything gets started the starting base stats are stored
	
func _process(_delta):
	handle_process_effects()

func handle_process_effects() :
	#reset the stats to the non-conditional values
	tank.stats = unconditional_stats.copy()
	#remove any boosts flagged for removal
	boost_list.filter(func(bh) : return !bh.remove)
	#add any conditional stat boosts
	for boost_holder in boost_list :
		#calls the boost specific functions, passes the tank
		for func_name in boost_holder.stat_boost.func_names :
			if func_name == "" : continue
			BoostFuncLibrary.call_from_lib(func_name, tank) #this line calls a one of the static functions in the StatBoost class

# Adding boosts

## Only adds the stats in the passed boost to the unconditional stats (the boost is not added to boost_list so its function will never be called)
## Cannot undo, except by calling subtract_boost_stats() and passing the same boost.
func add_boost_stats(boost : StatBoost) :
	unconditional_stats.add(boost) #see register_boost_holder() for explaination

## Creates and adds a new BoostHolder associated with a source
## Later you can use remove_all_boosts_from_source() to remove all boosts youve associated with a certain node
## or you can store the returned boost holder and use it later to call remove_boost()
## Returns the BoostHolder (you don't have to do anything with it)
func add_boost_with_source(boost : StatBoost, source : Node) -> BoostHolder :
	var bh := BoostHolder.create_with_source(boost, source)
	register_boost_holder(bh)
	return bh

## Creates and adds a new BoostHolder (not associated with a source)
## Optionally store the returned boost holder and use it later to call remove_boost()
## Returns the BoostHolder (you don't have to do anything with it)
## Alternatively, set the remove flag on StatBoost to true and it will be removed during the next frame (do this if you don't have a reference to the stats_handler anymore)
func add_boost(boost : StatBoost) -> BoostHolder :
	#adds a boost 
	var bh = BoostHolder.create_new(boost)
	register_boost_holder(bh)
	return bh
	
## Don't call this. Use add_boost() or add_boost_with_source()
func register_boost_holder(bh : BoostHolder) :
	#add the boost holder to the boost list
	boost_list.append(bh)
	#change the unconditional stats (eg if the item has damage +2, the player unconditional_stats damage will increase by 2)
	unconditional_stats.add(bh.stat_boost)
	#here we could also add something for a special on_added() for each boost if we want

# Removing boosts

## Only subtracts the stats in the passed boost to the unconditional stats (calling this does not affect the boost_list)
## Cannot undo, except by calling add_boost_stats() and passing the same boost.
func subtract_boost_stats(boost : StatBoost) :
	unconditional_stats.subtract(boost) #see unregister_boost_holder() for explaination

## Removes all boosts (from the boost list of this Stats Handler) that have the passed source as their source
func remove_all_boosts_from_source(source : Node) :
	for i in range(boost_list.size()-1, -1, -1) :
		if boost_list.get(i).has_source && boost_list.get(i).source == source :
			_unregister_boost_holder(boost_list.get(i))

## Removes a Boost contained in the passed Boost Holder 
func remove_boost(bh : BoostHolder) :
	_unregister_boost_holder(bh)
	
## Don't call this. Use remove_boost() or remove_all_boosts_from_source()
func _unregister_boost_holder(bh : BoostHolder) :
	#change the unconditional stats (eg if the item has damage +2, the player unconditional_stats damage will decrease by 2)
	unconditional_stats.subtract(bh.stat_boost) #item.item_res is an ItemResource which is an extension of StatBoost
	#here we could also add something for a special on_removed() for each boost if need be
	#remove the boost holder from the boost list (boost holders are not added to lists twice)
	for i in boost_list.size() : 
		if bh == boost_list[i] :
			boost_list.remove_at(i)
			break
