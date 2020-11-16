extends Area2D

export(PackedScene) var new_scene
onready var player = get_parent().find_node("Player")


func _on_SceneSwitcher_body_entered(body):
	if body == player:
		Globals.player_default_position = Vector2(64, 1080 - 540)
		SceneSwitcher.change_scene(new_scene)
	
