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

signal connection_outcome_determined(success : bool)

func _ready():
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func setup_as_host() :
	# Create a server (set peer to listen on PORT)
	var result = peer.create_server(PORT, MAX_CLIENTS)
	if result : #if it didn't work
		PopupDialouge.create_popup("Error", 300,400, "Could not create server")
		return
	
	# Set the godot internal peer
	multiplayer.multiplayer_peer = peer
	# Switch to the player game scene
	GameContainer.GC.switch_to_scene("player_field_1")
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func setup_as_client() -> bool :
	var result = peer.create_client(SERVER_ADDRESS, PORT)
	if result : #if it didn't work
		PopupDialouge.create_popup("Error", 300,400, "Could not connect to server")
		return false
	
	# Set the godot internal peer
	multiplayer.multiplayer_peer = peer
	
	#await to confirm successful connection
	var success = await connection_outcome_determined
	if !success :
		PopupDialouge.create_popup("Error", 300,400, "Error: Server does not exist")
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		return false
	
	# Switch to the player game scene
	GameContainer.GC.switch_to_scene("player_field_1")
	GameContainer.GC.switch_to_opponent_scene("opponent_field_1")
	return true

func _on_peer_connected(peer_id) :
	GameContainer.GC.switch_to_opponent_scene("opponent_field_1")

func _on_peer_disconnected(peer_id) :
	PopupDialouge.create_popup("Opponent Disconnected", 300,400, "Opponent disconected. Peer: " + str(peer_id))
	GameContainer.GC.destroy_opponent_scene()

func _on_server_disconnected() :
	PopupDialouge.create_popup("Server Disconnected", 300,400, "Server disconected")
	GameContainer.GC.destroy_opponent_scene()
	GameContainer.GC.switch_to_scene("main_menu")

func _on_connection_failed() :
	connection_outcome_determined.emit(false)

func _on_connected() :
	connection_outcome_determined.emit(true)
