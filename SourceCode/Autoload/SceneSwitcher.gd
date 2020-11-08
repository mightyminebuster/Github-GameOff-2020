extends CanvasLayer

signal scene_changed()

func change_scene(scene: PackedScene, delay: int = 0.5) -> void:
	yield(get_tree().create_timer(delay), "timeout")
	$AnimationPlayer.play("FadeToBlack")
	yield($AnimationPlayer, "animation_finished")
	assert(get_tree().change_scene_to(scene) == OK)
	$AnimationPlayer.play("FadeFromBlack")
	yield($AnimationPlayer,"animation_finished")
	emit_signal("scene_changed")
