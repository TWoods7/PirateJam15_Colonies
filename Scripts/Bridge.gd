extends Node2D

@onready var bridge = get_node("CollisionShape2D")
var state : bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_visibility_changed():
	state = !state
	bridge.disabled = !state
