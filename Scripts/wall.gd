extends Node2D

@onready var wall = get_node("CollisionShape2D") # Assigns the var as the Collision Child Node
var state = false # Used for flipping the bridges collision
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visibility_changed():
	if wall != null:
		state = !state # Flips state to either true or false
		wall.disabled = state #Disables the Colliders Collision
	else:
		pass
