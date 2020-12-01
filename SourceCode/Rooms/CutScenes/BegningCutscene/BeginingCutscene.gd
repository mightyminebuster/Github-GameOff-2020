extends Node2D

onready var next_scene = load("res://Rooms/Level-Jail-1.tscn")

func _ready():
	$AnimationPlayer.queue("EndLoop")
	
func _process(delta):
	if $AnimationPlayer.current_animation == "EndLoop":
		if Input.is_action_just_pressed("jump"):
			SceneSwitcher.change_scene(next_scene)
