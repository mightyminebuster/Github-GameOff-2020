extends ColorRect

var is_paused: bool = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if is_paused == true:
			is_paused = false
			get_tree().paused = false
			visible = false
		elif is_paused == false:
			is_paused = true
			get_tree().paused = true
			visible = true
	
