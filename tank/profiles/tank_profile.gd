extends Resource
class_name TankProfile

### Tank Profile ###
## All tanks have a TankProfile stored in Tank.profile. You must provide a TankProfile when creating a new Tank.
## TankProfiles can be reused (same resource attached to various tanks, for example for a bunch of npc tanks with the same colors etc)
## If a tank profile is only attached to one tank, it can be associated with that tank
## Tanks controlled by a player should use a PlayerProfile, which extends from TankProfile.
## Different player tanks should get different PlayerProfile objects. 

#tank association
var has_associated_tank : bool = false
var associated_tank_id : int

# tank settings #TODO
#var tank_color
#var tank_secondary_color

func is_player() :
	return typeof(PlayerProfile)

func associate(tank_id : int) :
	has_associated_tank = true
	associated_tank_id = tank_id

func dissociate() :
	has_associated_tank = false
	
