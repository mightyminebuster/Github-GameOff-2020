extends Sprite


export var distance_from_player: int = 64 #distance hint is from player in pixes

func _process(_delta : float) -> void:
	position = (get_global_mouse_position() - get_parent().global_position).normalized() * Vector2(distance_from_player, distance_from_player)
	
