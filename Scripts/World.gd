extends Node2D
@onready var player = $Player
@onready var bottom_bound = 100
@onready var starting_spawn = $Starting_Spawn

# Called when the node enters the scene tree for the first time.
func _ready():
	player.global_position = starting_spawn.global_position

func _process(delta):
	if player.global_position.y > bottom_bound: #Game over if below bottom bound
		game_over()
	
func game_over(): # Teleports player to start or a checkpoint
	print("game over")
	if Checkpoints.spawn:
		player.global_position = Checkpoints.spawn
	else:
		player.global_position = starting_spawn.global_position
