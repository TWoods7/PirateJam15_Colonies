extends Area2D

@export var is_on_node = false

func _on_body_entered(body):
	if body.is_in_group("Clive"):
		is_on_node = true
	else:
		pass


func _on_body_exited(body):
	if body.is_in_group("Clive"):
		is_on_node = false
	else:
		pass
