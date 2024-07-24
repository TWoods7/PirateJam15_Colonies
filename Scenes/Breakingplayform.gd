extends Area2D


func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			$AnimationPlayer.play("idle")
			$AnimationPlayer.play("destroyed")
			queue_free()
		else:
			$AnimationPlayer.play("idle")

