extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
var move_speed = 300.0
var jump_force = -350.0  
var bottom_bound = 150
var jump_count = 0
var max_jumps = 2
var gravity = 20


func _physics_process(delta):
	movement_control(delta)
	move_animation()
	
func game_over(): #Reloads scene when death
	get_tree().reload_current_scene()
	
func move_animation(): # Hold animations for the movement
	if Input.is_key_pressed(KEY_RIGHT) and is_on_floor(): #Plays Running Right animation when moving on floor
		_animated_sprite.play("runRight")
	elif Input.is_key_pressed(KEY_LEFT) and is_on_floor(): #Plays Running Left animation when moving on floor
		_animated_sprite.play("runLeft")
	else: #Stays idle when not moving
		_animated_sprite.stop()

func movement_control(delta): # Holds all movement control
	if not is_on_floor(): #Applies gravity if not in floor
		velocity.y += gravity
	if is_on_floor():
		jump_count = 0
		
	velocity.x = 0 #Set's to zero so it isn't constantly moving
	
	if Input.is_key_pressed(KEY_LEFT): #Velocity left for moving left
		velocity.x -= move_speed 
	if Input.is_key_pressed(KEY_RIGHT):#Velocity right for moving right
		velocity.x += move_speed
	
	if jump_count < max_jumps: 
		if Input.is_action_just_pressed("ui_accept") : #Velocity for the jump
			velocity.y = jump_force
			jump_count+=1
		
	if global_position.y > bottom_bound: #Game over if below bottom bound
		game_over()
	move_and_slide()
	

