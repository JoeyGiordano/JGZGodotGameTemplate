extends Node
class_name _GameManager

### AUTOLOAD

### GameManager
## Manages the flow of the game with game_loop. Mostly calls methods in other autoloads and sends/receives signals.

## Signals
signal players_ready
signal beginning_of_round
signal end_of_round

func _ready() :
	game_loop()

func game_loop() :
	await players_ready
	create_player_tanks()
	#temp
	# PlayerManager.get_associated_tank(0).tank_rigidbody.get_loadout().get_child(0).get_child(1).modulate = Color.BLUE #change one tank color
	var winner = -1
	while true :
		await load_next_level()
		beginning_of_round.emit()
		await end_of_round
		#end_round()
		#winner = check_for_winner()
		if winner != -1 :
			break
	reset()
	#show_victory_screen(winner)
	game_loop()

### GAME FLOW/LOGIC ###

func create_player_tanks() :
	pass

func load_next_level() :
	ShellSceneManager.switch_overlay_panel(Ref.loading) #this loading thing is actually completely unecessary it just looks nice
	ShellSceneManager.switch_active_scene(Ref.game_shell_scene, false)
	await Global.OverlayPanelHolder.get_child(0).display_score()
	LevelLoader.next_level()
	#var timer = get_tree().create_timer(0.7)
	#await timer.timeout
	ShellSceneManager.close_overlay_panel() # close loading overlay
	GameInfo.in_game = true

func tank_died() : 
	#called by a tank when it dies (if needed later, this method can take the Tank as a param)
	#calls end of round 2.5 seconds after the most recent tank death (like in the og game!)
	var tanks_alive : int = GameInfo.alive_players_count()
	if tanks_alive == 1 :
		var timer = get_tree().create_timer(2.5)
		await timer.timeout
		if GameInfo.alive_players_count() == 0 : return #if the last surviving player died while the timer was running, let the new timer that was created when it died run out before ending the scene
		end_of_round.emit()
	if tanks_alive == 0 :
		var timer = get_tree().create_timer(2.5)
		await timer.timeout
		end_of_round.emit()

func reset() :
	LevelLoader.remove_level()
	GameInfo.reset_scores()
