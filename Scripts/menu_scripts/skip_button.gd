extends Button

func _on_pressed():
	get_tree().change_scene_to_file("res://Scenes/Forest_Level.tscn")


func _on_mouse_entered():
	$"../../Hover".play()
