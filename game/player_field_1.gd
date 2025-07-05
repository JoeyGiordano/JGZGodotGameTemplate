extends Node2D
class_name PlayerField1

@onready var label : Label = $Label
@onready var message : Label = $MessageLabel
@onready var rect : ColorRect = $ColorRect
@onready var button1 : Button = $Button
@onready var button2 : Button = $Button2
@onready var leave_button : Button = $LeaveButton

func _ready():
	button1.connect("button_down", _on_button1_pressed)
	button2.connect("button_down", _on_button2_pressed)
	leave_button.connect("button_down", _on_leave_button_pressed)
	$IDLabel.text = str(multiplayer.get_unique_id())
	if multiplayer.get_unique_id() == 1 : leave_button.text = "End"

func _on_button1_pressed() :
	if waiting_for_opponent() : return
	if label.modulate == Color.BLUE : label.modulate = Color.WHITE
	else : label.modulate = Color.BLUE
	rpc("_on_button1_pressed_for_peer")

@rpc("any_peer")
func _on_button1_pressed_for_peer() :
	var labelx : Label = GameContainer.GC.OpponentSceneHolder.get_child(0).get_child(0)
	if labelx.modulate == Color.RED : labelx.modulate = Color.WHITE
	else : labelx.modulate = Color.RED

func _on_button2_pressed() :
	if waiting_for_opponent() : return
	var rand_color = get_random_color()
	rect.color = rand_color
	rpc("_on_button2_pressed_for_peer", rand_color)

@rpc("any_peer")
func _on_button2_pressed_for_peer(color : Color) :
	rect.color = color

func _on_leave_button_pressed() :
	#if multiplayer.get_unique_id() == 1 : #host end button pressed
	if multiplayer.multiplayer_peer :
		multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	#else : #client leave button pressed
	
	GameContainer.GC.destroy_opponent_scene()
	GameContainer.GC.switch_to_scene("main_menu")

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
