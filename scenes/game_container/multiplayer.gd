extends Node
class_name Multiplayer

# Port that server is listening for communications on
const PORT = 123
# The IP address of the server
const SERVER_ADDRESS = "loaclhost"

# Create peer object using ENet networking library
var peer = ENetMultiplayerPeer.new()

func setup_as_host() :
	# Create a server (set peer to listen on PORT)
	peer.create_server(PORT)
	# Set the godot internal peer
	multiplayer.multiplayer_peer = peer
	# Switch to the player game scene
	GameContainer.GC.switch_to_scene("player_field_1")
	
	multiplayer.peer_connected.connect(on_peer_connected)
	
func setup_as_client() :
	peer.create_client(SERVER_ADDRESS, PORT)
	# Set the godot internal peer
	multiplayer.multiplayer_peer = peer
	# Switch to the player game scene
	GameContainer.GC.switch_to_scene("player_field_1")

func on_peer_connected(peer_id) :
	print("Player joined")
