extends Node

var num_players = 30
var bus = "master"

var available = []  # The available players
var queue = []  # The queue of sounds to play

func _ready():
	# Create the pool of AudioStreamPlayer nodes
	for i in num_players:
		var player = AudioStreamPlayer.new()
		add_child(player)
		available.append(player)
		player.finished.connect(_on_stream_finished.bind(player))
		player.bus = bus

func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again
	available.append(stream)

func play(stream : AudioStream):
	# Queue an audio stream to play
	if queue.size() > 30 : return
	queue.append(stream)

func play_path(stream_path : String):
	# Queue a audio stream to play from its path
	if queue.size() > 30 : return
	queue.append(stream_path)

func _process(_delta):
	# Play as many queued sounds as there are available players
	while available.size() != 0 :
		_try_play_next()

func _try_play_next() :
	# Play a queued sound if any players are available
	if queue.size() != 0 and available.size() != 0 :
		if queue.front() is String :
			available[0].stream = load(queue.pop_front())
		else :
			available[0].stream = queue.pop_front()
		available[0].play()
		available.pop_front()
