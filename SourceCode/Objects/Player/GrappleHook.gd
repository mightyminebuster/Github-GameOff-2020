extends Node2D

#Node Refrences
onready var camera = get_parent().get_parent().find_node("Camera2D")

var length: int = 700
var direction: Vector2 = Vector2.ZERO

var tip: Vector2 = Vector2.ZERO
var tip_target: Vector2 = Vector2.ZERO
var speed: int = 25

var pull: int = 50
var is_shooting: bool = false


func shoot():
	$RayCast2D.enabled = true
	is_shooting = true
	$GrappleTip.visible = true #set the tip of the hook to visible
	get_parent().find_node("GrappleLine").visible = true #set the line to visible
	
	
	if $RayCast2D.is_colliding():
		if $RayCast2D.get_collider().collision_layer == 1:
			camera.shake(20, 10) #Shake Camer
			tip_target = $RayCast2D.get_collision_point()
			
		elif $RayCast2D.get_collider().collision_layer == 2:
			camera.shake(20, 5)
			tip_target = $RayCast2D.get_collision_point()
			return $RayCast2D.get_collision_point()
	else:
		tip_target = $RayCast2D.cast_to
	return null

func release() -> void:
	tip = get_parent().find_node("AimingHint").global_position #set tips resting position
	tip_target = tip #reset tip_target
	is_shooting = false #reset is_shooting
	
	$GrappleTip.visible = false
	get_parent().find_node("GrappleLine").visible = false

func _physics_process(_delta : float):
	if is_shooting:
		tip.x = move_toward(tip.x, tip_target.x, speed)
		tip.y = move_toward(tip.y, tip_target.y, speed)
		
		$GrappleTip.global_position = tip
		get_parent().find_node("GrappleLine").points[1] = $GrappleTip.position
	else:
		$RayCast2D.cast_to = (get_global_mouse_position() - get_parent().position).normalized() * Vector2(length, length)
		
		tip = get_parent().find_node("AimingHint").global_position #set tips resting position
