extends Node2D

var length: int = 700
var direction: Vector2 = Vector2.ZERO
var tip: Vector2 = Vector2.ZERO
var a = Vector2(100, 100)

var speed: int = 40


func shoot():
	$RayCast2D.enabled = true
	if $RayCast2D.is_colliding():
		$GrappleTip.visible = true
		get_parent().find_node("GrappleLine").visible = true
		tip = $RayCast2D.get_collision_point()
		return tip
	return null

func release() -> void:
	tip = get_parent().global_position
	$GrappleTip.visible = false
	get_parent().find_node("GrappleLine").visible = false

func _physics_process(_delta : float):
	$RayCast2D.cast_to = (get_global_mouse_position() - get_parent().position).normalized() * Vector2(length, length)
	
	$GrappleTip.global_position = tip
	get_parent().find_node("GrappleLine").points[1] = $GrappleTip.position
