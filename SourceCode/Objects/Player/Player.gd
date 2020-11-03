extends KinematicBody2D


#State Machine
var states: Array = ["idle", "run", "fall", "jump", "die"]
var current_state: String = states[0]
var previous_state: String
var state_origin: Object = self #where is the state defined

#Input	
var movement_direction: float = 0
var direction_facing: int = 1

#General
var velocity: Vector2 = Vector2.ZERO

var turn_animation_speed: float = 0.24

#Horizontal Movement
var current_speed: float = 0
var running_velocity: float 
var move_horizontally_states: Array = ["run", "fall", "jump", "double_jump"]

const max_speed: int = 400
const acceleration: int = 60
const decceleration: int = 100

#Aerial Movement
const gravity: int = 1700
const air_friction: int = 51
const gravity_exemption_states: Array = ["die", "dash"]
const terminal_vertical_velocity: int = 150

#Jump / Double Jump
const jump_height: int = 172
const double_jump_height: int = 128

var is_double_jumped: bool = false

var jumping_states: Array = ["jump", "double_jump"]

#Grapple
var target
var grapple_velocity: Vector2 = Vector2.ZERO

#Loop Functions
func _physics_process(delta : float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		set_state("die")
	
	state_origin.call(current_state + "_logic", delta)
	get_input()
	velocity = move_and_slide(velocity, Vector2.UP)
	if current_state in move_horizontally_states:
		if direction_facing == 1 && running_velocity < velocity.x || direction_facing == -1 && running_velocity > velocity.x:
			velocity.x -= running_velocity
	
	apply_gravity(delta)
	flip_sprite()

func get_input() -> void:
	movement_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if movement_direction != 0:
		direction_facing = int(movement_direction)

func apply_gravity(delta : float):
	if current_state in gravity_exemption_states:
		pass
	else:
		velocity.y += gravity * delta #idk why I apply delta here cause move and slide applies delta but it works and im not questioning it

func flip_sprite() -> void:
	$PlayerSprite.scale.x = move_toward($PlayerSprite.scale.x, direction_facing, turn_animation_speed)


#Common Functions
func set_state(new_state : String, state_originator: Object = self) -> void:
	#change state values
	previous_state = current_state
	current_state = new_state
	state_origin = state_originator
	
	#call methods
	if previous_state != null:
		state_origin.call(previous_state + "_exit_logic")
	if current_state != null:
		state_origin.call(current_state + "_enter_logic")

func move_horizontally(subtrahend : int) -> void:
	current_speed = move_toward(current_speed, max_speed - subtrahend, acceleration)
	running_velocity = current_speed * movement_direction
	velocity.x += running_velocity


func jump(height : int) -> void:
	var jump_velocity: float = -sqrt(2 * gravity * height) #define what velocity we would have to jump at to make the apex of our jump equal to jump height
	velocity.y = jump_velocity #apply that velocity to velocity


#Define state functions below
func idle_enter_logic() -> void:
	velocity.x = 0

func idle_logic(_delta : float) -> void:
	#Exit State
	if movement_direction != 0:
		set_state("run")
	
	if Input.is_action_just_pressed("jump"):
		set_state("jump")
	
	if Input.is_action_just_pressed("shoot"):
		set_state("grapple")

func idle_exit_logic() -> void:
	current_speed = 0 #we reset current speed here to maintain momentum on run-up jumps 



func run_enter_logic() -> void:
	pass

func run_logic(_delta : float) -> void:
	move_horizontally(0)
	
	#Exit State
	if movement_direction == 0:
		set_state("idle")
	
	if !is_on_floor():
		set_state("fall")
	
	if Input.is_action_just_pressed("jump"):
		set_state("jump")
		
	if Input.is_action_just_pressed("shoot"):
		set_state("grapple")

func run_exit_logic() -> void:
	pass 



func fall_enter_logic() -> void:
	pass

func fall_logic(_delta : float) -> void:
	move_horizontally(air_friction)

	if Input.is_action_just_pressed("jump") && !is_double_jumped:
		set_state("double_jump")
		
	if Input.is_action_just_pressed("shoot"):
		set_state("grapple")
	
	#Exit States
	if is_on_floor():
		set_state("idle")
		is_double_jumped = false #reset

func fall_exit_logic() -> void:
	pass 



func jump_enter_logic() -> void:
	jump(jump_height) #set y velocity

	if previous_state == "dash":
		set_state("fall")

func jump_logic(_delta : float) -> void:
	move_horizontally(air_friction)
	
	if Input.is_action_just_pressed("shoot"):
		set_state("grapple")
	
	#Exit State
	if velocity.y > 0:
		#switch state to fall if velocity is positive
		set_state("fall")

	if is_on_ceiling():
		#switch state to fall if you bonk the ceiling
		set_state("fall")
	
	if Input.is_action_just_released("jump"):
		#cut ascent in half if jump button is released
		velocity.y /= 4

func jump_exit_logic() -> void:
	pass 



func double_jump_enter_logic() -> void:
	is_double_jumped = true
	jump(double_jump_height)

func double_jump_logic(_delta : float) -> void:
	move_horizontally(air_friction)
	
	if Input.is_action_just_pressed("shoot"):
		set_state("grapple")
	
	#Exit State
	if velocity.y > 0:
		#switch state to fall if velocity is positive
		set_state("fall")

	if is_on_ceiling():
		#switch state to fall if you bonk the ceiling
		set_state("fall")
	
	if Input.is_action_just_released("jump"):
		#cut ascent in quarter if jump button is released
		velocity.y /= 4

func double_jump_exit_logic() -> void:
	pass 



func grapple_enter_logic() -> void:
	target = $GrappleHook.shoot()

func grapple_logic(_delta : float) -> void:
	if Input.is_action_just_released("shoot"):
		set_state("fall")
	if target == null:
		set_state("fall")
	else:
		grapple_velocity = (target - position).normalized() * $GrappleHook.speed
		
		if grapple_velocity.y > 0:
			# Pulling down isn't as strong
			grapple_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			grapple_velocity.y *= 1.2
		
		velocity += grapple_velocity

func grapple_exit_logic() -> void:
	$GrappleHook.release() 



func die_enter_logic() -> void:
	velocity = Vector2.ZERO #Stop all movement

func die_logic(_delta : float) -> void:
	get_tree().reload_current_scene()

func die_exit_logic() -> void:
	pass
