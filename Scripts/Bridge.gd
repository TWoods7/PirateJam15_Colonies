extends Node2D

@onready var bridge = get_node("CollisionShape2D") # Assigns the var as the Collision Child Node
var state = false # Used for flipping the bridges collision
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	pass
	
#-- Flips the Collider to disabled or !disabled based on its visibility change --#
func _on_visibility_changed(): 
	state = !state # Flips state to either true or false
	bridge.disabled = !state #Disables the Colliders Collision
#--------------------------------------------------------------------------------#
