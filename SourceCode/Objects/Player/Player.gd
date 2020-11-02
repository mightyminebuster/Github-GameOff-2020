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
const max_speed: int = 400
const acceleration: int = 60
const decceleration: int = 100

#Aerial Movement
const gravity: int = 1200
const air_friction: int = 51
const gravity_exemption_states: Array = ["die", "dash"]
const terminal_vertical_velocity: int = 150

#Jump / Double Jump
const jump_height: int = 172
const double_jump_height: int = 128

var is_double_jumped: bool = false

var jumping_states: Array = ["jump", "double_jump"]

#Loop Functions
func _physics_process(delta : float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		set_state("die")
	
	state_origin.call(current_state + "_logic", delta)
	get_input()
	velocity = move_and_slide(velocity, Vector2.UP)
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
	$Sprite.scale.x = move_toward($Sprite.scale.x, direction_facing, turn_animation_speed)


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
	velocity.x = current_speed * movement_direction


func jump(height : int) -> void:
	var jump_velocity: float = -sqrt(2 * gravity * height) #define what velocity we would have to jump at to make the apex of our jump equal to jump height
	velocity.y = jump_velocity #apply that velocity to velocity


#Define state functions below
func idle_enter_logic() -> void:
	pass

func idle_logic(_delta : float) -> void:
	#Deccelerate
	velocity.x = move_toward(velocity.x, 0, decceleration)

	#Exit State
	if movement_direction != 0:
		set_state("run")
	
	if Input.is_action_just_pressed("jump"):
		set_state("jump")

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

func run_exit_logic() -> void:
	pass 



func fall_enter_logic() -> void:
	velocity.y = 0

func fall_logic(_delta : float) -> void:
	move_horizontally(air_friction)

	if Input.is_action_just_pressed("jump") && !is_double_jumped:
		set_state("double_jump")
		

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


func die_enter_logic() -> void:
	velocity = Vector2.ZERO #Stop all movement

func die_logic(_delta : float) -> void:
	get_tree().reload_current_scene()

func die_exit_logic() -> void:
	pass
