extends CharacterBody2D


const move_speed = 300.0
const jump_force = -400.0
@export var bottom_bound = 150
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	velocity.x = 0
	
	if Input.is_key_pressed(KEY_LEFT):
		velocity.x -= move_speed
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.x += move_speed
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = jump_force
		
	if global_position.y > bottom_bound:
		_game_over()
	move_and_slide()
func _game_over():
	get_tree().reload_current_scene()
