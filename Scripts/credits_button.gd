extends Button

@onready var audio_player = $AudioStreamPlayer

func _on_pressed():
	print("credits pressed")

func _on_mouse_entered():
	$Hover3.play()
