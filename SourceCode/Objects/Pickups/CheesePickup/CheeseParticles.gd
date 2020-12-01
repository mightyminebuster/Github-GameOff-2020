extends CPUParticles2D

var previous_position : Vector2

func _ready():
	position = previous_position

func _process(delta : float) -> void:
	if !emitting:
		free()
