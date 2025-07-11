extends Node2D
class_name PlayerField1

@onready var player_scene : PackedScene = preload("res://game/player.tscn")

@onready var label : Label = $Label
@onready var message : Label = $MessageLabel
@onready var rect : ColorRect = $ColorRect
@onready var ready_button : Button = $ReadyButton
@onready var smth_button : Button = $SmthButton
@onready var leave_button : Button = $LeaveButton

#players
var players : Array[Player]

func _enter_tree():
	set_multiplayer_authority(multiplayer.get_unique_id())

func _ready():
	ready_button.connect("button_down", _on_ready_button_pressed)
	smth_button.connect("button_down", _on_smth_button_pressed)
	leave_button.connect("button_down", _on_leave_button_pressed)
	$IDLabel.text = str(multiplayer.get_unique_id())
	if multiplayer.get_unique_id() == 1 :
		leave_button.text = "End"
		$IDLabel.text = "Host: " + str(MultiplayerManager.game_code)

# Signal response

func _on_ready_button_pressed() :
	if waiting_for_opponent() : return
	if label.modulate == Color.BLUE : label.modulate = Color.WHITE
	else : label.modulate = Color.BLUE
	label.text = "Ready"
	ready_button.disabled = true
	ready_button.visible = false
	rpc("_on_ready_button_pressed_for_peer")
	var labelx : Label = GameContainer.GC.OpponentSceneHolder.get_child(0).get_child(0)
	if labelx.text == "Ready" :
		start_game()

@rpc("any_peer")
func _on_ready_button_pressed_for_peer() :
	var labelx : Label = GameContainer.GC.OpponentSceneHolder.get_child(0).get_child(0)
	if labelx.modulate == Color.RED : labelx.modulate = Color.WHITE
	else : labelx.modulate = Color.RED
	labelx.text = "Ready"
	if label.text == "Ready" :
		start_game()

func start_game() :
	var labelx : Label = GameContainer.GC.OpponentSceneHolder.get_child(0).get_child(0)
	label.visible = false
	labelx.visible = false
	ready_button.disabled = true
	ready_button.visible = false
	smth_button.disabled = true
	smth_button.visible = false
	rect.visible = false
	spawn_players()
	$EnemySpawner.start_game()

func _on_smth_button_pressed() :
	var rand_color = get_random_color()
	rect.color = rand_color
	rpc("_on_smth_button_pressed_for_peer", rand_color)

@rpc("any_peer")
func _on_smth_button_pressed_for_peer(color : Color) :
	rect.color = color

func _on_leave_button_pressed() :
	if multiplayer.multiplayer_peer :
		multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	
	GameContainer.GC.destroy_opponent_scene()
	GameContainer.GC.switch_to_scene("main_menu")

# Resource

func get_random_color() -> Color:
	var hue = randf_range(0.0, 1.0)
	var saturation = randf_range(0.5, 1.0)
	var value = randf_range(0.6, 1.0)
	return Color.from_hsv(hue, saturation, value)

func waiting_for_opponent() -> bool :
	if multiplayer.get_peers().size() < 1 :
		display_message("Waiting for opponent to join")
		return true
	return false

func display_message(text : String) :
	message.text = text
	var t : Timer = message.get_child(0)
	t.start()
	await t.timeout
	message.text = ""
	t.stop()

func spawn_players() :
	#player 1 (self)
	var player1 : Player = player_scene.instantiate()
	player1.name = str(multiplayer.get_unique_id()) #set the name to the id of the game instance creating these nodes
	add_child(player1)
	players.append(player1)
	#player 2 (opponent)
	var player2 : Player = player_scene.instantiate()
	player2.name = str(multiplayer.get_peers()[0]) #two player game so get_peers()[0] is the only peer (bc it doesn't include self)
	add_child(player2)
	players.append(player2)
	#positioning
	if multiplayer.get_unique_id() == 1 :
		player1.position = Vector2(400,300)
		player2.position = Vector2(600,300)
	else :
		player1.position = Vector2(600,300)
		player2.position = Vector2(400,300)
	#other setup
	player1.in_play = true
	player2.in_play = true
	
	
