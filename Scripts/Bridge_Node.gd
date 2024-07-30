extends Area2D

@export var is_on_node = false

func _on_body_entered(body):
	is_on_node = true


func _on_body_exited(body):
	is_on_node = false
