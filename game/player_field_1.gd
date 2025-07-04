extends Node2D
class_name PlayerField1

@onready var label : Label = $Label
@onready var rect : ColorRect = $ColorRect
@onready var button1 : Button = $Button
@onready var button2 : Button = $Button2

func _ready():
	button1.connect("button_down", on_button1_pressed)
	button2.connect("button_down", on_button2_pressed)
	$IDLabel.text = str(multiplayer.get_unique_id())

func on_button1_pressed() :
	if multiplayer.get_peers().size() < 1 :
		label.text = "Waiting for opponent"
		var timer = get_tree().create_timer(1.5)
		await timer.timeout
		label.text = "Player text"
		return
	if label.modulate == Color.BLUE : label.modulate = Color.WHITE
	else : label.modulate = Color.BLUE
	rpc("on_button1_pressed_for_peer")

@rpc("any_peer")
func on_button1_pressed_for_peer() :
	var labelx : Label = GameContainer.GC.OpponentSceneHolder.get_child(0).get_child(0)
	if labelx.modulate == Color.RED : labelx.modulate = Color.WHITE
	else : labelx.modulate = Color.RED

func on_button2_pressed() :
	var rand_color = get_random_color()
	rect.color = rand_color
	rpc("on_button2_pressed_for_peer", rand_color)

@rpc("any_peer")
func on_button2_pressed_for_peer(color : Color) :
	rect.color = color

func get_random_color() -> Color:
	var hue = randf_range(0.0, 1.0)
	var saturation = randf_range(0.5, 1.0)
	var value = randf_range(0.6, 1.0)
	return Color.from_hsv(hue, saturation, value)
