extends Node2D


onready var next_scene = load("res://Rooms/CutScenes/BegningCutscene/BeginingCutscene.tscn")

func _ready():
	$AnimationPlayer.queue("EndLoop")

func _process(delta : float) -> void:
	if !$MusicPlayer.playing:
		$MusicPlayer.playing = true

	if Input.is_action_just_pressed("jump"):
		$ConfirmSFX.play()
		SceneSwitcher.change_scene(next_scene)
