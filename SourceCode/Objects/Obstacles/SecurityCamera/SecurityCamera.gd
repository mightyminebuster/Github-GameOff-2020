extends Position2D

func _physics_process(_delta : float) -> void:
	for raycast in find_node("Raycasts").get_children():
		if raycast.is_colliding():
			if raycast.get_collider().collision_layer == 2147483652:
				raycast.get_collider().set_state("die")
