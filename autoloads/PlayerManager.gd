extends Node
class_name _PlayerManager

### AUTOLOAD

### PlayerManager ###
## Provides methods for creating, setting up, and destroying PlayerProfiles.
## Each player has a unique player_id that is stored in the PlayerProfile. Provides method to access players from their player_id.

var next_id : int = 0

var players : Array[PlayerProfile] # each player has a unique id number, the id is not associated with the position in this array

## Get

func get_player_profile(player_id : int) -> PlayerProfile :
	for p : PlayerProfile in players :
		if p.player_id == player_id :
			return p
	return null

func get_associated_tank(player_id : int) -> Tank :
	var p : PlayerProfile = get_player_profile(player_id)
	return TankManager.get_tank(p.associated_tank_id)

func player_count() -> int :
	return players.size()

## Reset

func reset_player_scores() :
	for p : PlayerProfile in players :
		p.score = 0

func reset() :
	delete_all_players()
	next_id = 0

## Create

func create_players(count : int) :
	for i in range(count) :
		create_player()

func create_player() -> PlayerProfile :
	# create unique id
	var player_id = next_id
	next_id += 1
	# create a PlayerProfile
	var p : PlayerProfile = PlayerProfile.new() #creates a default tank profile, essentially the player settings
	# add to players array
	players.append(p) #add the new profile to the players array
	# setup
	p.player_id = player_id
	_create_and_assign_keybinds(p)
	return p

## Delete

func delete_player(player_id : int) :
	_delete_player(get_player_profile(player_id))

func delete_all_players() :
	for i in range(players.size() - 1, -1, -1) :
		_delete_player(players[i])

func _delete_player(p : PlayerProfile) :
	if p.has_associated_tank :
		# remove the tank, etc
		pass
	#adjust UI
	#_delete_keybinds(p) NOTE may need to add this back in when adding keybinds editing
	players.remove_at(players.find(p))

## Keybinds Manipulation

func _create_and_assign_keybinds(p : PlayerProfile) :
	var prefix : String = "player" + str(p.player_id)
	# Create NOTE this may need to be added back when adding keybinds editing
	#InputMap.add_action(prefix + "_left")
	#InputMap.add_action(prefix + "_right")
	#InputMap.add_action(prefix + "_up")
	#InputMap.add_action(prefix + "_down")
	#InputMap.add_action(prefix + "_shoot")
	# Assign default keys to keybinds
	# Assign action names to profile
	p.key_LEFT = prefix + "_left"
	p.key_RIGHT = prefix + "_right"
	p.key_UP = prefix + "_up"
	p.key_DOWN = prefix + "_down"
	p.key_SHOOT = prefix + "_shoot"

func _delete_keybinds(p : PlayerProfile) :
	var prefix : String = "player" + str(p.player_id)
	InputMap.erase_action(prefix + "_left")
	InputMap.erase_action(prefix + "_right")
	InputMap.erase_action(prefix + "_up")
	InputMap.erase_action(prefix + "_down")
	InputMap.erase_action(prefix + "_shoot")
