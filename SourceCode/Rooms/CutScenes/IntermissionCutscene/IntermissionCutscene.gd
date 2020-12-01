extends Node2D

var new_scene = load("res://Rooms/Level-Industrial-1.tscn")

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("jump"):
		SceneSwitcher.change_scene(new_scene)
		$ConfirmSFX.play()
