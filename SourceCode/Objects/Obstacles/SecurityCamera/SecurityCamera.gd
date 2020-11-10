extends Position2D
export var speed: float = 1

func _physics_process(_delta : float) -> void:
	if !Engine.editor_hint:
		for raycast in find_node("RotationFix").find_node("Raycasts").get_children():
			if raycast.is_colliding():
				if raycast.get_collider().collision_layer == 2147483652:
					raycast.get_collider().set_state("die")


func _process(delta):
	$RotationFix/AnimationPlayer.playback_speed = speed
