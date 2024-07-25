extends Area2D


func _on_body_entered(body):
	Checkpoint.spawn = global_position
