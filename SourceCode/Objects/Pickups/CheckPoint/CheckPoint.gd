extends Area2D



func _on_CheckPoint_body_entered(body):
	Globals.player_default_position = position - Vector2(0, 64)
	$AnimationPlayer.play("FlagUp")
