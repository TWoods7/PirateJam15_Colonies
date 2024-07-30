extends Area2D

func _on_ready():
	$AnimationPlayer.play("idle")

func _on_body_entered(body):
	if body.is_in_group("Clive"):
		Checkpoints.spawn = null
		var current_scene = get_tree().current_scene.scene_file_path
		var next_lvl = current_scene.to_int() + 1
		var next_lvl_path = "res://Scenes/levels/Level" + str(next_lvl) + ".tscn"
		get_tree().change_scene_to_file(next_lvl_path)
