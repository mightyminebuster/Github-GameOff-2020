extends Node

var player_default_position: Vector2 = Vector2(64, 64)
var has_grappling_hook: bool = false

var player_default_gravity: int = 1700

var coin_count = 0

var raw_timer: float = 0
var string_timer: String = ""


func _process(delta):
	raw_timer = float(OS.get_ticks_msec()) #get time in ms
	raw_timer = stepify(raw_timer, 1000)
	
	
	string_timer = String(raw_timer) #convert to string
	string_timer = string_timer.substr(0, string_timer.length() - 3) #cut out miliseconds
	
#	var filler: int = 6
#	var filler_string: String = ""
#	filler -= string_timer.length() 
	
#	for x in filler:
#		filler_string += "0"
#	string_timer = filler_string + string_timer #add filler 0s
	
	
	#string_timer = string_timer.insert(string_timer.length() - 2, ":") #insert colons
	#string_timer = string_timer.insert(string_timer.length() - 5, ":")
