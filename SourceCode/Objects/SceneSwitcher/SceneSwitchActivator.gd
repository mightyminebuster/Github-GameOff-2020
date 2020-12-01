extends Area2D

export(PackedScene) var new_scene


func _on_SceneSwitchActivator_body_entered(body):
	SceneSwitcher.change_scene(new_scene)
	Globals.player_default_position = Vector2(64, 64)
