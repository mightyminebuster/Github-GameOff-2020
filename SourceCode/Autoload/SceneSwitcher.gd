extends CanvasLayer

signal scene_changed()

func change_scene(scene: PackedScene, speed: int = 2) -> void:
	$AnimationPlayer.playback_speed = speed
	$AnimationPlayer.play("FadeToBlack")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene_to(scene)
	$AnimationPlayer.play("FadeFromBlack")
	yield($AnimationPlayer,"animation_finished")
	emit_signal("scene_changed")
