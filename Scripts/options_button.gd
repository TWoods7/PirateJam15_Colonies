extends Button

func _on_pressed():
	print("options pressed")

func _on_mouse_entered():
	$"../Hover".play()
