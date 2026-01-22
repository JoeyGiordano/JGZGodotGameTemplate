extends Node
class_name _Debug

### AUTOLOAD

### Debug ###
## This autoload stores permanent debug tools for easy access

func _process(_delta):
	#quit if DEBUG_QUIT key pressed - DEBUG
	if Input.is_action_pressed("DEBUG_QUIT") : get_tree().quit()

## Signal viewing ##

func print_node_signal_connections(node : Node, do_print : bool = true) -> String :
	# Iterate over all signals defined in this node and print their connections
	var output : String = "" # prep to store the printed strings
	for _signal in node.get_signal_list(): # cycle through every signal in the node
		output += "Signal: " + _signal.name + "\n" + "---" + "\n" # store header
		var connections = node.get_signal_connection_list(_signal.name) # get the signal's connections
		for c in connections : # cycle through every connection (array of dicts)
			var method_name = str(c.get("callable", "_")) # the connected method
			var flags = str(c.get("flags", "_")) # the flags associated with the connected method
			output += method_name + "\t\t\t" + flags + "\n" # store the connection info
		output += "-------------" + "\n" # store footer
	if do_print : print(output) # print
	return output

func print_signal_connections(s : Signal, do_print : bool = true) -> String :
	#print all connections to the signal s, return the printout string, optionally don't print
	#Note: if two instances of the same object are connected to the same signal, it counts as two connections and will be listed twice
	var output : String = "" # prep to store the printed strings
	output += "Signal: " + s.get_name() + "\n" + "---" + "\n" # store header
	var connections = s.get_connections() # get the signal's connections
	for c in connections :  # cycle through every connection (array of dicts)
		var method_name = str(c.get("callable", "_")) # the connected method
		var flags = str(c.get("flags", "_")) # the flags associated with the connected method
		output += method_name + "\t\t\t" + flags + "\n" # store the connection info
	output += "-------------" + "\n" # store footer
	if do_print : print(output) # print
	return output
