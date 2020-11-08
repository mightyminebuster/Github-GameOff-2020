extends Area2D

export(PackedScene) var new_scene
onready var player = get_parent().find_node("Player")


func _on_SceneSwitcher_body_entered(body):
	if body == player:
		SceneSwitcher.change_scene(new_scene)
