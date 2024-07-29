extends Button

func _on_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level1.tscn")


func _on_mouse_entered():
	$"../../Hover".play()
