extends Node
class_name Connect

@onready var host_button : Button = $HostButton
@onready var connect_botton : Button = $ConnectButton
@onready var message_label : Label = $MessageLabel

func _ready():
	host_button.connect("button_down", host_button_pressed)
	connect_botton.connect("button_down", connect_button_pressed)

func host_button_pressed() :
	disable_buttons()
	message_label.text = "Setting up server..."
	MultiplayerManager.setup_as_host()

func connect_button_pressed() :
	disable_buttons()
	message_label.text = "Trying to connect..."
	MultiplayerManager.setup_as_client()

func disable_buttons() :
	host_button.disabled = true
	host_button.visible = false
	connect_botton.disabled = true
	connect_botton.visible = false
