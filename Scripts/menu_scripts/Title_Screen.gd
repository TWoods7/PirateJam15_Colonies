extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicController.play_title_music()
	set_process(false)

