extends Area2D


func _on_body_entered(body):
	Checkpoints.spawn = global_position
	
