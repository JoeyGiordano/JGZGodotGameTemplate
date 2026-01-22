extends Node

@onready var add_player_button : Button = $AddPlayerButton
@onready var remove_player_button : Button = $RemovePlayerButton
@onready var message_label : Label = $MessageLabel
@onready var play_button : Button = $PlayButton

var player_count : int = 1

func _ready() : 
	add_player_button.pressed.connect(on_add_player_pressed)
	remove_player_button.pressed.connect(on_remove_player_pressed)
	play_button.pressed.connect(on_play_pressed)

func _process(_delta) :
	if Input.is_action_just_pressed("DEBUG_SKIP") :
		player_count = 2
		play_button.pressed.emit()

func on_add_player_pressed() :
	if player_count < 3 :
		player_count += 1
		add_update_graphic()
	else :
		message_label.text = "Player max reached"
		await get_tree().create_timer(1.7).timeout
		message_label.text = ""

func on_remove_player_pressed() :
	if player_count > 1 :
		player_count -= 1
		remove_update_graphic()

func on_play_pressed() :
	PlayerManager.create_players(player_count)

func add_update_graphic() :
	match player_count :
		2 : 
			$PlayerGraphic1.hide()
			$PlayerGraphic2.show()
		3 :
			$PlayerGraphic2.hide()
			$PlayerGraphic3.show()

func remove_update_graphic() :
	match player_count :
		1 : 
			$PlayerGraphic2.hide()
			$PlayerGraphic1.show()
		2 :
			$PlayerGraphic3.hide()
			$PlayerGraphic2.show()
