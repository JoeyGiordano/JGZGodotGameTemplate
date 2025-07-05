extends Node
class_name Multiplayer

# Port that server is listening for communications on
const PORT = 123
# The IP address of the server
const SERVER_ADDRESS = "localhost"
# Max clients, not including host (doesn't work for local clients)
const MAX_CLIENTS = 1 #this is a two player game

# Create peer object using ENet networking library
var peer = ENetMultiplayerPeer.new()

func _ready():
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func setup_as_host() :
	# Create a server (set peer to listen on PORT)
	var result = peer.create_server(PORT, MAX_CLIENTS)
	if result :
		PopupDialouge.create_popup("Error", 300,400, "Could not create server")
		return
	
	# Set the godot internal peer
	multiplayer.multiplayer_peer = peer
	# Switch to the player game scene
	GameContainer.GC.switch_to_scene("player_field_1")
	
	multiplayer.peer_connected.connect(on_peer_connected)

func setup_as_client() :
	var result = peer.create_client(SERVER_ADDRESS, PORT)
	if result : 
		PopupDialouge.create_popup("Error", 300,400, "Could not connect to server")
		return
	
	# Set the godot internal peer
	multiplayer.multiplayer_peer = peer
	# Switch to the player game scene
	GameContainer.GC.switch_to_scene("player_field_1")
	GameContainer.GC.switch_to_opponent_scene("opponent_field_1")

func on_peer_connected(peer_id) :
	GameContainer.GC.switch_to_opponent_scene("opponent_field_1")

func _on_server_disconnected() :
	PopupDialouge.create_popup("Server Disconnected", 300,400, "Error: server disconected")
