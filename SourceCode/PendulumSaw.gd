tool
extends Position2D

export(String, "FullRotation", "HalfRotation") var rotation_type = "HalfRotation"
export var offset: int = 128
export var speed: float = 1 

func _ready():
	$AnimationPlayer.play(rotation_type)
func _process(_delta : float) -> void:
	
	$AnimationPlayer.playback_speed = speed
	
	$Line2D.points[1] = Vector2(0, offset)
	$Area2D.position = Vector2(0, offset) 
