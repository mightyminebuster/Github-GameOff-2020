extends Area2D

export(PackedScene) var new_scene
onready var player = get_parent().find_node("Player")

func _physics_process(_delta : float) -> void:
	var is_player_entered = overlaps_body(player)
	if is_player_entered:
		$SceneSwitchEffect.change_scene("res://Objects/Player/Player.tscn")
