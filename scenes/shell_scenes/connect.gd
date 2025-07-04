extends Node
class_name Connect

@onready var host_button : Button = $HostButton
@onready var connect_botton : Button = $ConnectButton
@onready var message : Label = $MessageLabel

func _ready():
	host_button.connect("button_down", host_button_pressed)
	connect_botton.connect("button_down", connect_button_pressed)

func host_button_pressed() :
	message.text = "Trying to host..."

func connect_button_pressed() :
	message.text = "Trying to connect..."
