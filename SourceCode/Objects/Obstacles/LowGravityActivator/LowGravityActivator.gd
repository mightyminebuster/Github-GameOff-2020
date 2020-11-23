extends Area2D



func _on_LowGravityActivator_body_entered(body):
	if body.name == "Player":
		print("a")
		body.gravity /= 2
		body.jump_multiplier = 2


func _on_LowGravityActivator_body_exited(body):
	print(body, "  ", body.name)
	if body.name == "Player":
		print("b")
		body.gravity *= 2
		body.jump_multiplier = 1
