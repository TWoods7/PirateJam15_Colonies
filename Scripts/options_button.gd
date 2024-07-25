extends Button

@onready var audio_player = $AudioStreamPlayer

func _on_pressed():
	print("options pressed")




func _on_mouse_entered():
	$Hover2.play()
