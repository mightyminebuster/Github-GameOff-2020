extends Node2D

#Node Refrences
onready var camera = get_parent().get_parent().find_node("Camera2D")

var length: int = 700
var direction: Vector2 = Vector2.ZERO

var tip: Vector2 = Vector2.ZERO
var tip_target: Vector2 = Vector2.ZERO
var speed: int = 50

var pull: int = 50


func shoot():
	$RayCast2D.enabled = true
	if $RayCast2D.is_colliding():
		camera.shake(20, 10)
		$GrappleTip.visible = true
		get_parent().find_node("GrappleLine").visible = true
		tip_target = $RayCast2D.get_collision_point()
		return $RayCast2D.get_collision_point()
	return null

func release() -> void:
	tip = get_parent().global_position
	tip_target = tip
	$GrappleTip.visible = false
	get_parent().find_node("GrappleLine").visible = false

func _physics_process(_delta : float):
	$RayCast2D.cast_to = (get_global_mouse_position() - get_parent().position).normalized() * Vector2(length, length)
	tip = tip_target
	
	
	$GrappleTip.global_position = tip
	get_parent().find_node("GrappleLine").points[1] = $GrappleTip.position
