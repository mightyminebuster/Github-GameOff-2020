extends Node

var current_playing: String

func check_playing():
	#checks all audio stream players if they're playing anything
	#returns the audio stream, thats playing or null
	for child in get_children():
		#the most used sound effects should be near the top so the loop iterates less properties
		if child.playing == true:
			return child
	return null

func play(stream_player: String, new_volume_db: float = 0, new_pitch_scale: float = 1.0) -> void:
	for child in get_children():
		child.playing = false #stop all other sounds
		if child.name == stream_player:
			current_playing = stream_player
			
			child.volume_db = new_volume_db
			child.pitch_scale = new_pitch_scale
			child.playing = true

func stop():
	var p = check_playing()
	if p != null:
		p.playing = false
	


func _process(delta):
	print($Jump.playing)
