extends Object
class_name BoostFuncLibrary

### BoostFuncLibrary ###
## A library of static, boost specific functions for StatBoosts to use.
## When adding a new boost specific function, put it with all the other ones!

static var BFL : BoostFuncLibrary = BoostFuncLibrary.new()

static func call_from_lib(func_name : String, tank : Tank) :
	BFL.call(func_name, tank)

##### Boost Specific Functions #####

#EXAMPLE
"""
static func amulet_of_empowering_fear(player : Player) :
	if (player.is_scared) : 
		player.stats.top_speed += 10
"""

static func do_nothing(tank : Tank) :
	#for testing
	#print("nothing")
	tank.stats.backward_speed -= 20
	if tank.effects_handler.on_fire : tank.stats.backward_speed = 150
