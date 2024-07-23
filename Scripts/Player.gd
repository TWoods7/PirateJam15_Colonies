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

@onready var left_ray = $RayCast_Left
@onready var right_ray = $RayCast_Right
var did_left_jump = false
var did_right_jump = false
 
@onready var node = get_tree().get_first_node_in_group("Node")
@onready var bridge = get_tree().get_first_node_in_group("Bridge")
@onready var state = false

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
	
	if left_ray.is_colliding() or right_ray.is_colliding():
		max_jumps = 1 # Sets jump max to 1
		player_speed = move_speed * .70 # Lowers players speed untill they touch the floor again
		velocity = Vector2.ZERO # Stops player's momentum when colliding with a wall
		velocity.y += gravity * 0.4 # Slows gravity's effect on the player when on a wall
	if left_ray.is_colliding() and !did_right_jump:
		jump_count = 0
		did_right_jump = true
		did_left_jump = false
	if right_ray.is_colliding() and !did_left_jump:
		jump_count = 0
		did_left_jump = true
		did_right_jump = false
			
	if is_on_floor():
		did_left_jump = false
		did_right_jump = false
		max_jumps = 2 # Sets jump max to 2
		player_speed = move_speed #Reset player speed to base speed on floor
		jump_count = 0 # Resets Amount of times jumped
	
	if Input.is_action_just_pressed("dash") and can_dash:
		is_dashing = true
		can_dash = false
		$dash_timer.start()
		$can_dash_timer.start()
	
	if Input.is_key_pressed(KEY_LEFT): # Move left aslong as they didn't just jump right off a wall
		if is_dashing:
			velocity.x = direction * dash_speed
		else: 
			velocity.x = direction * player_speed # Moves the player left
		if is_on_floor:
			$AnimatedSprite2D.play("run")
	elif Input.is_key_pressed(KEY_RIGHT): # Move right aslong as they didn't just jump left off a wall
		if is_dashing:
			velocity.x = direction * dash_speed

		else:
			velocity.x = direction * player_speed # Moves the player right
		if is_on_floor:
			$AnimatedSprite2D.play("run")
	else: 
		velocity.x = 0
	
	if jump_count < max_jumps: #Checks if the player has jumped the max amount of time or not
		if Input.is_action_just_pressed("ui_accept"): #Checks if space was just pressed and not on a wall.
			velocity.y = jump_force #Moves player up
			jump_count+=1 #Increments jump count by 1 when you have jumped
			$AnimatedSprite2D.play("jump")
	
	if Input.is_action_just_pressed("plant_bridge"):
		state = !state
		bridge.visible = state
		
		
	if global_position.y > bottom_bound: #Game over if below bottom bound
		game_over()
		
	move_and_slide()

func _on_dash_timer_timeout():
	is_dashing = false;

func _on_can_dash_timer_timeout():
	can_dash = true
	
