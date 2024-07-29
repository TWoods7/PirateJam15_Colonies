extends Path2D

#can modify these exported variables with each new instance of a moving pltfm
##open path is a line, a closed path is a shape, like a circle
@export var is_open_path = true

##speed if path is open
@export var pltfm_speed = 2 

##speed if path is closed
@export var spd_scale = 1 

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

func _ready():
	#if path is open, movement will be as follows:
	if is_open_path: 
		animation.play("move")
		animation.speed_scale = spd_scale
		#don't call the process function anymore because we're using an animation to move the platform
		set_process(false) 

func _process(_delta):
	#if path is closed, movement will be as follows:
	path.progress += pltfm_speed
