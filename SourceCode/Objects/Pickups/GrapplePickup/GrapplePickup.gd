extends Area2D


func _ready():
	if Globals.has_grappling_hook == true:
		#delete node if the player has the hook
		queue_free()


func _on_GrapplePickup_body_entered(body):
	if body.name == "Player":
		Globals.has_grappling_hook = true
		queue_free()
