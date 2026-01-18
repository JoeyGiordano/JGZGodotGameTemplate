extends Node
class_name _GameInfo

### AUTOLOAD

### GameInfo ###
## Game state flags vars and funcs.

var in_game : bool = false
var score0 : int = 0
var score1 : int = 0
var score2 : int = 0

var num_players = 0

#
#func alive_players_count() -> int : #TODO NEXT move somewhere else?
	#var players_alive : int = 0 
	#for t : Tank in Global.PlayerTanks.get_children() :
		#if !t.dead :
			#players_alive += 1
	#return players_alive

func reset_scores() :
	score0 = 0
	score1 = 0
	score2 = 0
