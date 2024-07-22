extends CharacterBody2D
#
# DO NOT CHANGE A VAR TO A CONST UNLESS A COMMENT SAYS OTHERWISE
#
@onready var _animated_sprite = $AnimatedSprite2D

const move_speed : float = 200 # Variable that acts as constant so when player_speed is adjusted, the base move_speed still exists
var player_speed : float # Variable that represents players current speed

var gravity : float = 15 # The gravity var

var jump_force : float = -300  # How powerful the jump is (could be a const)
var bottom_bound : int = 150 # How many pixels down the death barrier is

var jump_count : int = 0 # How many time the player has jumped 
var max_jumps : int = 2 # The max amount of time's the player can jump

#-- Used for preventing people jumping on the same wall they just jumped off of --#
var did_left_jump : bool = false
var did_right_jump : bool = false

@onready var Left_Ray = $RayCast_Left
@onready var Right_Ray = $RayCast_Right

func _physics_process(delta):
	movement_control(delta)
	move_animation()

func game_over(): # Reloads scene when death
	get_tree().reload_current_scene()
	
func move_animation(): # Hold animations for the movement
	if Input.is_key_pressed(KEY_RIGHT) and is_on_floor(): #Plays Running Right animation when moving on floor
		_animated_sprite.play("runRight")
	elif Input.is_key_pressed(KEY_LEFT) and is_on_floor(): #Plays Running Left animation when moving on floor
		_animated_sprite.play("runLeft")
	elif Input.is_action_just_pressed("ui_accept") and (KEY_RIGHT):
		_animated_sprite.play("jumpRight")
	elif Input.is_action_just_pressed("ui_accept") and (KEY_LEFT):
		_animated_sprite.play("jumpLeft")
	else: #Stays idle when not moving
		_animated_sprite.stop()

func movement_control(delta): # Holds all movement control
	velocity.x = 0 # Set's to zero so it isn't constantly moving
	
	if not is_on_floor() and not is_on_wall(): # Applies gravity if not in floor and not on a wall
		velocity.y += gravity
		
	if Left_Ray.is_colliding() or Right_Ray.is_colliding():
		jump_count = 0 # Resets Amount of times jumped
		max_jumps = 1
		player_speed = move_speed * .70 # Lowers players speed untill they touch the floor again
		velocity.y = 0# Stops player's momentum when colliding with a wall
		velocity.y += gravity * 0.4 # Slows gravity's effect on the player when on a wall
		if Input.is_action_just_pressed("ui_accept") and Left_Ray.is_colliding():
			velocity.x += player_speed * 6
			velocity.y = 0# Stops player's momentum when colliding with a wall
			velocity.y += jump_force * 0.5
			jump_count+=1 #Increments jump count by 1 when you have jumped
		if Input.is_action_just_pressed("ui_accept") and Right_Ray.is_colliding():
			velocity.x += -move_speed * 6
			velocity.y = 0# Stops player's momentum when colliding with a wall
			velocity.y += jump_force * 0.5
			jump_count+=1 #Increments jump count by 1 when you have jumped
			
	if is_on_floor():
		max_jumps = 2 # Sets jump max to 2
		player_speed = move_speed #Reset player speed to base speed on floor
		jump_count = 0 # Resets Amount of times jumped
	
	if Input.is_action_pressed("left") and !is_on_wall():
		velocity.x = -move_speed
	if Input.is_action_pressed("right") and !is_on_wall():
		velocity.x = move_speed
	#Checks if the player has jumped the max amount of time or not
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps: #Checks if space was just pressed and not on a wall.
		velocity.y = jump_force #Moves player up
		jump_count+=1 #Increments jump count by 1 when you have jumped
		
	if global_position.y > bottom_bound: #Game over if below bottom bound
		game_over()
	move_and_slide()
	

