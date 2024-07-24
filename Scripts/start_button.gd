extends Button

func _on_pressed():
	print("start pressed")
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
