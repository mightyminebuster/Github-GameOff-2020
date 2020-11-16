extends Area2D

func _on_CheckPoint_area_entered(area):
	Globals.player_default_position = position - Vector2(0, 64)
	$FlagSprite.modulate = Color.green
