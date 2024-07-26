extends AudioStreamPlayer2D

const title_music = preload("res://Audio/Music/Homunculus.mp3")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	else:
		stream = music
		volume_db = volume
		set_bus("MUSIC")
		play()
		
func play_title_music():
	_play_music(title_music)
	
func stop_title_music():
	if stream == title_music:
		stop()
