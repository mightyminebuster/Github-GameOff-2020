extends Area2D


func _on_CheesePickup_body_entered(body):
	Globals.coin_count += 1
	queue_free()
