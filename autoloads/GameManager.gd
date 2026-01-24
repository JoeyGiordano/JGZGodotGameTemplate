extends Node
class_name _GameManager

### AUTOLOAD

### GameManager
## Manages the flow of the game with game_loop. Mostly calls methods in other autoloads and sends/receives signals.

func _ready() :
	game_loop()

func game_loop() :
	pass

### GAME FLOW/LOGIC ###

# game flow/logic functions here
