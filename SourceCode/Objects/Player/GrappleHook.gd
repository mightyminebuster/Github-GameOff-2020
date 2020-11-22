extends Node2D

#Node Refrences
onready var camera = get_parent().get_parent().find_node("Camera2D")

var length: int = 700
var direction: Vector2 = Vector2.ZERO

var t: float = 0 #t in the interpolation function
var tip: Vector2 = Vector2.ZERO
var tip_target: Vector2 = Vector2.ZERO

var speed: float = 0.07
var pull: int = 30
var is_shooting: bool = false


func shoot():
	$RayCast2D.enabled = true
	is_shooting = true
	$GrappleTip.visible = true #set the tip of the hook to visible
	get_parent().find_node("GrappleLine").visible = true #set the line to visible
	
	
	if $RayCast2D.is_colliding():
		if $RayCast2D.get_collider().collision_layer == 1:
			tip_target = $RayCast2D.get_collision_point()
			
			var r: Array = [null, 1]
			return r
			
		elif $RayCast2D.get_collider().collision_layer == 2:
			
			tip_target = $RayCast2D.get_collision_point()
			
			var r: Array = [$RayCast2D.get_collision_point(), 2]
			return r
	else:
		tip_target = $RayCast2D.cast_to + global_position
		
		var r: Array = [null, 0]
		return r

func release() -> void:
	tip = get_parent().find_node("AimingHint").global_position #set tips resting position
	tip_target = tip #reset tip_target
	is_shooting = false #reset is_shooting
	
	$GrappleTip.visible = false
	get_parent().find_node("GrappleLine").visible = false

func _physics_process(delta : float):
	
	
	if is_shooting:
		t += speed
		tip = tip.linear_interpolate(tip_target, t)
		
		$GrappleTip.global_position = tip
		get_parent().find_node("GrappleLine").points[1] = $GrappleTip.position
	else:
		t = 0
		$RayCast2D.cast_to = (get_global_mouse_position() - get_parent().position).normalized() * Vector2(length, length)
		
		tip = get_parent().find_node("AimingHint").global_position #set tips resting position
