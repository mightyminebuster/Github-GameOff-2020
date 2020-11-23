extends Area2D


func _on_MovementBlockActivator_body_entered(body):
	if body.name == "Player":
		body.can_move_horizontally = false


func _on_MovementBlockActivator_body_exited(body):
	if body.name == "Player":
		body.can_move_horizontally = true
