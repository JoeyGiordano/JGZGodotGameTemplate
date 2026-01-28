extends Node

### AUTOLOAD

### Debug ###
## This autoload stores permanent debug tools for easy access

func IS_DEBUG_ON() -> bool :
	# allows debug tools to be turned on and off from one place (change the var below)
	# for cleanup purposes, shows when debug calls are attempted when debug is off
	var debug_on : bool = true
	if !debug_on :
		push_warning("Debug call made while debug is off.")
	return debug_on

func IS_DEBUG_OFF() -> bool :
	return !IS_DEBUG_ON()

func _process(_delta):
	# quit if DEBUG_QUIT key pressed - DEBUG
	if IS_DEBUG_ON() && Input.is_action_pressed("DEBUG_QUIT") : get_tree().quit()

#region Signal Debug

func print_node_signal_connections(node : Node, do_print : bool = true) -> String :
	# Iterate over all signals defined in this node and print their connections
	if IS_DEBUG_OFF() : return ""
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
	# Print all connections to the signal s, return the printout string, optionally don't print
	#Note: if two instances of the same object are connected to the same signal, it counts as two connections and will be listed twice
	if IS_DEBUG_OFF() : return ""
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

#endregion
