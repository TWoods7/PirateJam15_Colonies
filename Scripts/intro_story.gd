extends Label

var intro_text = "A Homunculus, an incomplete being made of shadow,\ncreated by those who are in pursuit of knowledge\nwith the purpose of defining what it is to be human.\nOr so they say.\nSeveral years have passed since I was created\nwith no mention of my purpose - that is, until today.\nI was given a cloak, and set on a journey of self-\ndiscovery. “Go become a human” they said, but\nthey didn’t say how. Well, no use crying over spilled\nmercury.  I wonder what is out there for me to find.\nHere I go!"

func _ready():
	scroll_text(intro_text)
	set_process(false)

func scroll_text(input_text):
	visible_characters = 0
	text = input_text
	for i in text.length():
		visible_characters += 1
		if (text[i] != " "):
			await get_tree().create_timer(0.05).timeout
	
