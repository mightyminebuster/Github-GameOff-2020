extends KinematicBody2D

#State Vars
var states: Array = ["idle", "run", "fall", "jump", "double_jump"] #list of all states
var current_state: String = states[0] #what state's logic is being called every frame
var previous_state: String #last state that was being calles

#Nodes & paths
onready var camera: Camera2D = get_parent().find_node("Camera2D")
onready var player_sprite: Sprite = $PlayerSprite #path to the player's sprite

#Squash & Stretch
var recovery_speed: float = 0.03 #how fast you recover from squashes, and stretches

var landing_squash: float = 1.5 #x scale of PlayerSprite when you land
var landing_stretch: float = 0.5 #y scale of PlayerSprite when you land

var jumping_squash: float = 0.5 #x scale of PlayerSprite when you jump
var jumping_stretch: float = 1.5 #y scale of PlayerSprite when you jump

#Input Vars
var direction_moving: int = 0 #will be 1, -1, 0 depending on if you are holding right, left, or nothing
var direction_facing: int = 1 #last direction pressed that is not 0

#Movement Vars
var terminal_velocity: float = 1000
var velocity: Vector2 = Vector2.ZERO #linear velocity applied to move and slide

var current_speed: int = 0 #how much you add to x velocity when moving horizontally
var max_speed: int = 400 #maximum current speed can reach when moving horizontally
var acceleration: int = 60 #by how much does current speed approach max speed when moving
var decceleration: int = 200 #by how much does velocity approach when you stop moving horizontally
var air_friction: int = 150 #how much you subtract velocity when you start moving horizontally in the air

var move_horizontally_states: Array = ["run", "jump", "fall", "double_jump"]
var running_velocity: float = 0

#fall
var gravity: int = 1700 #how much is added to y velocity constantly

var jump_buffer_start_time: int  = 0 #ticks when you ran of the platform
var elapsed_jump_buffer: int = 0 #how many seconds passed in the jump nuffer
var jump_buffer: int = 100 #how many miliseconds allowance you give jumps after you run of an edge


#jump
var jump_height: int = 192  #How high the peak of the jump is in pixels

#double jump
var double_jump_height: int = 128 #How high the peak of the double jump is in pixels

var has_double_jumped: bool = false #if you have double jumped

#Grapple
var shoot_dump: Array
var target
var grapple_velocity: Vector2 = Vector2.ZERO

#die
var has_animation_started: bool = false

#Loop Functions
func _on_PlayerHitbox_area_entered(area):
	set_state("die")
func _on_PlayerHitbox_body_entered(body):
	set_state("die")

func _ready():
	position = Globals.player_default_position

func _physics_process(delta):
	print(current_state)

	get_input()
	
	apply_gravity(delta)
	
	call(current_state + "_logic", delta) #call the current states main method
	
	
	
	velocity = velocity.clamped(terminal_velocity)
	velocity = move_and_slide(velocity, Vector2.UP) #aply velocity to movement
	
	if current_state in move_horizontally_states && sign(velocity.x - running_velocity) == direction_moving:
		velocity.x -= running_velocity
	else:
		running_velocity= 0
	
	recover_sprite_scale()
	
	player_sprite.flip_h = direction_facing - 1 #flip sprite depending on which direction you last moved in

func get_input():
	#set input vars
	direction_moving = Input.get_action_strength("move_right") - Input.get_action_strength("move_left") #set movement input to 1,-1, or 0
	if direction_moving != 0:
		direction_facing = direction_moving #set last direction if movement input isnt 0

func apply_gravity(delta):
	#apply gravity in every state except dash
	velocity.y += gravity * delta

func recover_sprite_scale():
	#make sprite scale approach 0
	player_sprite.scale.x = move_toward(player_sprite.scale.x, 1, recovery_speed)
	player_sprite.scale.y = move_toward(player_sprite.scale.y, 1, recovery_speed)

func set_state(new_state : String):
	#update state values
	previous_state = current_state
	current_state = new_state
	
	#call enter/exit methods
	if previous_state != null:
		call(previous_state + "_exit_logic")
	if current_state != null:
		call(current_state + "_enter_logic")



#Functions used across multiple states
func move_horizontally(subtractor):
	current_speed = move_toward(current_speed, max_speed, acceleration) #accelerate current speed
	
	running_velocity = current_speed * direction_moving #apply curent speed to velocity and multiply by direction
	running_velocity = clamp(running_velocity, -max_speed, max_speed)
	velocity.x += running_velocity

func squash_stretch(squash, stretch):
	#set Sprite scale to squash and stretch
	player_sprite.scale.x = squash
	player_sprite.scale.y = stretch

func jump(jump_height):
	velocity.y = 0 #reset velocity
	velocity.y = -sqrt(2 * gravity * jump_height) #apply velocity
	
	squash_stretch(jumping_squash, jumping_stretch) #set squaash and stretch

#State Functions

func idle_enter_logic():
	pass

func idle_logic(delta):
	if Input.is_action_just_pressed("jump"):
		#jump if you press button
		set_state("jump")
	
	if Input.is_action_just_pressed("shoot"):
		#enter the grapple state if you press the button
		set_state("grapple")
		
	
	if direction_moving != 0:
		#start running if you press a movement button
		set_state("run")
	velocity.x = move_toward(velocity.x, 0, decceleration) #deccelerate


func idle_exit_logic():
	current_speed = 0 #reset current speed (we do this here to keep momentum on run jumps)
	


func run_enter_logic():
	current_speed = 0 #reset current speed (we do this here to keep momentum on run jumps)

func run_logic(delta):
	if Input.is_action_just_pressed("jump"):
		#jump if you press the jump button
		set_state("jump")
		
	if Input.is_action_just_pressed("shoot"):
		#enter the grapple state if you press the button
		set_state("grapple")

	if !is_on_floor():
		#if your not on a floor, start falling and set jumpbuffer start time
		jump_buffer_start_time = OS.get_ticks_msec()
		set_state("fall")
		
	
	if direction_moving == 0:
		#if your not pressing a move button go idle
		set_state("idle")
	else:
		#if pressing move button start moving
		move_horizontally(0)
	
func run_exit_logic():
	running_velocity = 0



func fall_enter_logic():
	#Anim.play("Fall") #play the fall animation
	pass

func fall_logic(delta):
	move_horizontally(air_friction) #move horizontally
	elapsed_jump_buffer = OS.get_ticks_msec() - jump_buffer_start_time #set elapsed time for jump buffer
	
	if Input.is_action_just_pressed("jump"):
		#if you press jump
		if !has_double_jumped && elapsed_jump_buffer > jump_buffer:
			#and jump is pressed outside the jump buffer window, and this is your first double jump
			set_state("double_jump") #set state to double jump
		
		if elapsed_jump_buffer < jump_buffer:
			#if your in the jump buffer window
			if previous_state == "run":
				#and your previpus state is run
				set_state("jump") #set state to jump
	
	if Input.is_action_just_pressed("shoot"):
		#enter the grapple state if you press the button
		set_state("grapple")
	
	if is_on_floor():
		#if player is on a floor
		set_state("run") #set state to run (we set to run to keep momentum)
		has_double_jumped = false #reset is double jumped
		
		squash_stretch(landing_squash, landing_stretch) #apply squash and stretch


func fall_exit_logic():
	jump_buffer_start_time = 0 #reset jump buffer start time



func jump_enter_logic():
	jump(jump_height)

func jump_logic(delta):
	move_horizontally(air_friction) #move horizontally and subtract airfriction from max speed
	
	if Input.is_action_just_pressed("shoot"):
		#enter the grapple state if you press the button
		set_state("grapple")
	
	if velocity.y < 0:
		#if you are rising
		if Input.is_action_just_released("jump"):
			#and you release jump button
			velocity.y /= 2 #lower velocity
			
		if Input.is_action_just_pressed("jump") && !has_double_jumped:
			#if its your first time double jumping
			set_state("double_jump") #set state to double jump

		if is_on_ceiling():
			#if you hit a ceiling
			set_state("fall") #start falling
	else:
		#if you are no longer rising
		set_state("fall") #fall
	
func jump_exit_logic():
	pass



func double_jump_enter_logic():
	jump(double_jump_height)
	has_double_jumped = true #make sure you can only double jump once

func double_jump_logic(delta):
	move_horizontally(air_friction) #move horizontally and subtract airfriction from max speed
		
	if velocity.y < 0:
		#if you are rising
		if Input.is_action_just_released("jump"):
			#and you release jump button lower velocity
			velocity.y /= 2
		
		if is_on_ceiling():
			#and you hit a ceiling 
			set_state("fall") #fall
	else:
		#if you are no longer rising
		set_state("fall") #fall

func double_jump_exit_logic():
	pass



func grapple_enter_logic() -> void:
	if Globals.has_grappling_hook == false:
		#dont grapple if dont have the hook
		if previous_state != "jump" && previous_state != "double_jump":
			set_state(previous_state)
		else:
			set_state("fall")
	else:
		shoot_dump = $GrappleHook.shoot()
		target = shoot_dump[0]

func grapple_logic(_delta : float) -> void:
	if Input.is_action_just_released("shoot"):
		set_state("fall")
	if typeof(target) != TYPE_VECTOR2 && $GrappleHook.tip == $GrappleHook.tip_target:
		if shoot_dump[1] == 1:
			camera.shake(10, 10)
		set_state("fall")
	
	if typeof(target) == TYPE_VECTOR2 && $GrappleHook.tip == $GrappleHook.tip_target:
		grapple_velocity = (target - position).normalized() * $GrappleHook.pull
		
		if grapple_velocity.y > 0:
			# Pulling down isn't as strong
			grapple_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			grapple_velocity.y *= 1.2
		
		if sign(grapple_velocity.x) == direction_facing:
			pass
		else:
			grapple_velocity.x *= 0.75
		velocity += grapple_velocity

func grapple_exit_logic() -> void:
	$GrappleHook.release() 



func die_enter_logic() -> void:
	velocity = Vector2.ZERO #Stop all movement

func die_logic(_delta : float) -> void:
	if !has_animation_started:
		has_animation_started = true
		SceneSwitcher.change_scene(load("res://Rooms/" + get_tree().current_scene.name + ".tscn"), 4)

func die_exit_logic() -> void:
	pass



