extends Area2D

var time = 1

func _ready():
	set_process(false)

func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			$AnimationPlayer.play("idle")
			$AnimationPlayer.play("destroy")
			call_deferred("queue_free")
		else:
			$AnimationPlayer.play("idle")
