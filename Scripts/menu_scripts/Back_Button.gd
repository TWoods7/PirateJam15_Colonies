extends Button

func _on_pressed():
	print("back button pressed")
	get_tree().change_scene_to_file("res://Scenes/menu_scenes/Title_Screen.tscn")

func _on_mouse_entered():
	$"../../Hover".play()
