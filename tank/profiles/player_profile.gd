extends TankProfile
class_name PlayerProfile

## PlayerProfile
## An extension of TankProfile with additional info for players.
## Different player tanks should get different PlayerProfile objects. 

# Player
var player_id : int

# Score
var score : int = 0

# Keybinds
# only need to set these to anything if this is a player (bots are controlled directly through method calls)
# these are the names of the associated actions in the input map (eg "player1_up" "player2_right")
var key_LEFT : String
var key_RIGHT : String
var key_UP : String
var key_DOWN : String
var key_SHOOT : String
