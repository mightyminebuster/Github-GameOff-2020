extends Node2D

var length: int = 500
var direction: Vector2 = Vector2.ZERO
var tip: Vector2 = Vector2.ZERO
var a = Vector2(100, 100)

var speed: int = 20

var is_flying: bool = false
var is_hooked: bool = false

func shoot():
	$RayCast2D.enabled = true
	if $RayCast2D.is_colliding():
		print($RayCast2D.get_collision_point())
		global_position = $RayCast2D.get_collision_point()
		return $RayCast2D.get_collider()
	return null

func release() -> void:
	position = Vector2(0,0)

func _physics_process(_delta : float):
	$RayCast2D.cast_to = (get_global_mouse_position() - get_parent().position).normalized() * Vector2(length, length)
