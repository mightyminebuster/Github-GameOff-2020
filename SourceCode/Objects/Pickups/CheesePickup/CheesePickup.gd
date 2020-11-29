extends Area2D

onready var particles = load("res://Objects/Pickups/CheesePickup/CheeseParticles.tscn")

func _on_CheesePickup_body_entered(body):
	Globals.coin_count += 1
	var i = particles.instance()
	i.emitting = true
	i.previous_position = global_position
	get_tree().get_root().add_child(i)
	queue_free()
