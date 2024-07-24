extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$Timer.start(0.5) #how much time player gets before pltfm is destroyed

func _on_timer_timeout():
	set_process(false)
	$AnimationPlayer.play("destroyed")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "destroyed":
		queue_free()
