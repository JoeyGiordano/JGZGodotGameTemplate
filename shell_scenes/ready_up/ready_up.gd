extends Node

#for now, assume two players. This code waits until both of them have pressed their shoot button before starting the game
#this is a bit of a haphazard way to do it, but it'll need a full revamp for multiple players and art. so this works for now

var most_recent_press : int = 0

var players_ready_already_called : bool = false

func _process(_delta):
	if Input.is_action_pressed("player0_shoot") :
		if most_recent_press == 2 :
			players_ready()
		most_recent_press = 1
	if Input.is_action_pressed("player1_shoot") :
		if most_recent_press == 1 :
			players_ready()
		most_recent_press = 2
	if Input.is_action_just_pressed("DEBUG_SKIP") :
		players_ready()

func players_ready() :
	if players_ready_already_called : return #ensures GameManager.game_loop() is only called once
	players_ready_already_called = true
	GameManager.players_ready.emit()
