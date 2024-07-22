extends CharacterBody2D
#
# DO NOT CHANGE A VAR TO A CONST UNLESS A COMMENT SAYS OTHERWISE
#
@onready var _animated_sprite = $AnimatedSprite2D

const move_speed : float = 200 # Variable that acts as constant so when player_speed is adjusted, the base move_speed still exists
var player_speed : float # Variable that represents players current speed

const gravity : float = 15 # The gravity var

var jump_force : float = -300  # How powerful the jump is (could be a const)
var bottom_bound : int = 150 # How many pixels down the death barrier is

var jump_count : int = 0 # How many time the player has jumped 
var max_jumps : int = 2 # The max amount of time's the player can jump

#-- Used for preventing people jumping on the same wall they just jumped off of --#
var did_left_jump : bool = false
var did_right_jump : bool = false

const dash_speed = 900
var is_dashing = false
var can_dash = true

# func that's called every frame
func _physics_process(delta):
	movement_control(delta)
	move_animation()
	
func game_over(): # Reloads scene when death
	get_tree().reload_current_scene()
	
func move_animation(): # Hold animations for the movement
	var direction = Input.get_axis("left", "right")
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true
	if direction == 0 and is_on_floor():
		$AnimatedSprite2D.play("idle")
	if direction != 0 and not is_on_floor():
		$AnimatedSprite2D.play("fall")
		

func movement_control(delta): # Holds all movement control
	var direction = Input.get_axis("left", "right")
	if (not is_on_floor() and not is_on_wall()): # Applies gravity if not in floor and not on a wall
		velocity.y += gravity
		$AnimatedSprite2D.play("fall")
	
	if is_on_wall():
		jump_count = 0 # Resets Amount of times jumped
		max_jumps = 1 # Sets jump max to 1
		did_left_jump = false # Resets directional jump checker
		did_right_jump = false # Resets directional jump checker
		player_speed = move_speed * .70 # Lowers players speed untill they touch the floor again
		velocity = Vector2.ZERO # Stops player's momentum when colliding with a wall
		velocity.y += gravity * 0.4 # Slows gravity's effect on the player when on a wall
		
		#-- If statement for preventing the player from changing direction mid-air after wall jump--#
		if Input.is_action_just_pressed("left")  :
			did_left_jump = true
		elif Input.is_action_just_pressed("right") :
			did_right_jump = true
			
	if is_on_floor():
		max_jumps = 2 # Sets jump max to 2
		did_left_jump = false # Resets directional jump checker
		did_right_jump = false # Resets directional jump checker
		player_speed = move_speed #Reset player speed to base speed on floor
		jump_count = 0 # Resets Amount of times jumped
	
	if Input.is_action_just_pressed("dash") and can_dash:
		is_dashing = true
		can_dash = false
		$dash_timer.start()
		$can_dash_timer.start()
	
	if Input.is_key_pressed(KEY_LEFT) and !did_right_jump: # Move left aslong as they didn't just jump right off a wall
		if is_dashing:
			velocity.x = direction * dash_speed
		else: 
			velocity.x = direction * player_speed # Moves the player left
		if is_on_floor:
			$AnimatedSprite2D.play("run")
	elif Input.is_key_pressed(KEY_RIGHT) and !did_left_jump: # Move right aslong as they didn't just jump left off a wall
		if is_dashing:
			velocity.x = direction * dash_speed

		else:
			velocity.x = direction * player_speed # Moves the player right
		if is_on_floor:
			$AnimatedSprite2D.play("run")
	else: 
		velocity.x = 0
	
	if jump_count < max_jumps: #Checks if the player has jumped the max amount of time or not
		if Input.is_action_just_pressed("ui_accept") and !is_on_wall() : #Checks if space was just pressed and not on a wall.
			velocity.y = jump_force #Moves player up
			jump_count+=1 #Increments jump count by 1 when you have jumped
			$AnimatedSprite2D.play("jump")
		
	if global_position.y > bottom_bound: #Game over if below bottom bound
		game_over()
	move_and_slide()
	

func _on_dash_timer_timeout():
	is_dashing = false;

func _on_can_dash_timer_timeout():
	can_dash = true
