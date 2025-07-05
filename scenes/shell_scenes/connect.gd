extends Node
class_name Connect

@onready var host_button : Button = $HostButton
@onready var host_local_button : Button = $HostLocalButton
@onready var connect_botton : Button = $ConnectButton
@onready var message_label : Label = $MessageLabel
@onready var joincode_textbox : TextEdit = $JoinCodeTextBox

func _ready():
	host_local_button.connect("button_down", _on_host_local_button_pressed)
	host_button.connect("button_down", _on_host_button_pressed)
	connect_botton.connect("button_down", connect_button_pressed)

func _on_host_button_pressed() :
	host_button_pressed(false)

func _on_host_local_button_pressed() :
	host_button_pressed(true)
	
func host_button_pressed(local : bool) :
	disable_buttons()
	message_label.text = "Setting up server..."
	var success = await MultiplayerManager.setup_as_host(local)
	if !success :
		message_label.text = ""
		enable_buttons()

func connect_button_pressed() :
	disable_buttons()
	message_label.text = "Trying to connect..."
	var success = await MultiplayerManager.setup_as_client(joincode_textbox.text)
	if !success :
		message_label.text = ""
		enable_buttons()

func disable_buttons() :
	host_button.disabled = true
	connect_botton.disabled = true

func enable_buttons() :
	host_button.disabled = false
	connect_botton.disabled = false
