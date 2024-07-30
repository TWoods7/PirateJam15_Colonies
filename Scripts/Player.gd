extends CharacterBody2D
#
# DO NOT CHANGE A VAR TO A CONST UNLESS A COMMENT SAYS OTHERWISE
#
@onready var animation = $AnimatedSprite2D

var check = false

const move_speed : float = 200 # Variable that acts as constant so when player_speed is adjusted, the base move_speed still exists
var player_speed : float # Variable that represents players current speed

const gravity : float = 15 # The gravity var
const terminal_velocity : int = 350

var jump_force : float = -250  # How powerful the jump is (could be a const)
var jump_count : int = 0 # How many time the player has jumped 
var max_jumps : int = 2 # The max amount of time's the player can jump

@onready var left_ray = $RayCast_Left #The ray that tells if something is on the players left
@onready var right_ray = $RayCast_Right #The ray that tells if something is on the players right
var did_left_jump = false # Check for if player just jumped to the left
var did_right_jump = false # Check for if player just jumped to the right
 
@onready var nodes = get_tree().get_nodes_in_group("Node") # The array of nodes that are in the group Node
@onready var bridges = get_tree().get_nodes_in_group("Bridge") # The array of nodes that are in the group Bridge
var index = 0 # Index for accessing different set of bridges and their nodes
var state = false # Used for flipping the bridges visibilty and collision

const dash_speed = 900 #Speed for when you/re dashing
var is_dashing = false #check for if the player is currently dashing
var can_dash = true #Check for if cooldown is over and the player can dash

var has_double_jump = true
var has_dash = true
var has_bridge = true
var has_wall_jump = true

@onready var jump_audio = $jump_audio
@onready var dash_audio = $dash_audio

# func that's called every frame
func _physics_process(delta):
	#print(global_position)
	movement_control(delta)
	move_animation()
	#-- Breaks level into seperate areas where the plant bridge you change is decided--#
	if global_position.x > 1950 and global_position.x< 1975:
		index = 1
	elif global_position.x > 2110 and global_position.x< 2130:
		index = 0
	elif global_position.x > 2575 and global_position.x< 2600:
		index = 2
	elif global_position.x > 3825 and global_position.x< 3850:
		index = 3
	#----------------------------------------------------------------------------------#

@warning_ignore("unused_parameter")
func movement_control(delta): # Holds all movement control
	var direction = Input.get_axis("left", "right")
	
	if (not is_on_floor() and not is_on_wall()): # Applies gravity if not in floor and not on a wall
		if (velocity.y < terminal_velocity):
			velocity.y += gravity
		else:
			velocity.y = terminal_velocity
	
	if left_ray.is_colliding() or right_ray.is_colliding(): # Check for if anything is to the left or right of the player and has a collider
		max_jumps = 1 # Sets jump max to 1
		player_speed = move_speed * .70 # Lowers players speed untill they touch the floor again
		velocity.y += gravity * 0.4 # Slows gravity's effect on the player when on a wall
		
	#-- Check for if the player has jump from a left wall to a right(or vice-versa) used to preventing cheesing the wall jump--#
	if left_ray.is_colliding() and !did_right_jump and has_wall_jump:
		jump_count = 0
		did_right_jump = true
		did_left_jump = false
	if right_ray.is_colliding() and !did_left_jump and has_wall_jump:
		jump_count = 0
		did_left_jump = true
		did_right_jump = false
	#--------------------------------------------------------------------------------------------------------------------------#
	
	if is_on_floor():
		did_left_jump = false # Resets the wall jump checker
		did_right_jump = false # Resets the wall jump checker
		if has_double_jump:
			max_jumps = 2 # Sets jump max to 2
		else:
			max_jumps = 1
		player_speed = move_speed #Reset player speed to base speed on floor
		jump_count = 0 # Resets Amount of times jumped
		
	#-- Check for if player tried to dash and can dash --#
	if Input.is_action_just_pressed("dash") and can_dash and has_dash: 
		is_dashing = true # States player is dashing
		can_dash = false # States they can't dash
		$dash_timer.start() # Starts timer for the player's dash
		$can_dash_timer.start() # Starts timer for cooldown
		$dash_audio.play()
	#----------------------------------------------------#
	
	if Input.is_key_pressed(KEY_LEFT): # Check if player pressed left key
		if is_dashing:
			velocity.x = direction * dash_speed # Moves player left faster
		elif is_on_floor: 
			velocity.x = direction * player_speed # Moves the player left normally
	elif Input.is_key_pressed(KEY_RIGHT): # Check if player pressed right key
		if is_dashing:
			velocity.x = direction * dash_speed # Moves player right faster
		elif is_on_floor:
			velocity.x = direction * player_speed # Moves the player right normally
	else: 
		velocity.x = 0 # stops player if they aren't trying to move
	
	if Input.is_key_pressed(KEY_DOWN) and is_on_floor():
		position.y += 1
	
	if jump_count < max_jumps: #Checks if the player has jumped the max amount of time or not
		if Input.is_action_just_pressed("ui_accept"): #Checks if space was just pressed
			velocity.y = jump_force #Moves player up
			jump_count+=1 #Increments jump count by 1 when you have jumped
			jump_audio.play()
	
	if Input.is_action_just_pressed("plant_bridge") and has_bridge:
		if bridges.is_empty() and nodes.is_empty():
			pass
		else:
			if nodes[index].is_on_node:
				state = !state # Flips state to either true or false
				bridges[index].visible = state #Makes the specific bridge in the array be either visible or !visible
			else:
				pass
	
	if check == true:
		move_and_slide()
	else:
		check = true
	
func move_animation(): # Holds all animations for the movement
	var direction = Input.get_axis("left", "right")
	if direction > 0:
		animation.flip_h = false
	elif direction < 0:
		animation.flip_h = true
	
	if is_dashing:
		animation.play("dash")
	elif velocity.x != 0 and is_on_floor():
		animation.play("run")
	elif velocity.x == 0 and velocity.y == 0:
		animation.play("idle")
	elif velocity.y > 0:
		animation.play("fall")
	elif velocity.y < 0 and not is_on_floor():
		animation.play("jump")

func _on_dash_timer_timeout(): #Stops player from dashing after the timer is up
	is_dashing = false;

func _on_can_dash_timer_timeout(): # Allows the player to dash after the cooldown is up
	can_dash = true
