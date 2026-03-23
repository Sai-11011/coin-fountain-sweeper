extends Node2D

@onready var coin_scene: PackedScene = load(Global.SCENES.coin)
@onready var spawn_timer: Timer = $Timers/SpawnTimer

# Temporary score tracker for testing
var score: int = 0 

func _on_spawn_timer_timeout() -> void:
	print("YO")
	spawn_coin()

func spawn_coin() -> void:
	if not coin_scene:
		return
	var new_coin = coin_scene.instantiate()
	var toss_side = randi() % 2
	if toss_side == 0:
		# TOSS FROM THE LEFT
		# Spawn outside the left wall, near the top
		new_coin.position = Vector2(100, 100)
		# Throw it UP (negative Y) and RIGHT (positive X)
		var throw_x = randf_range(200.0, 450.0) 
		var throw_y = randf_range(-200.0, -400.0)
		new_coin.linear_velocity = Vector2(throw_x, throw_y)
	else:
		# TOSS FROM THE RIGHT
		# Spawn outside the right wall, near the top
		new_coin.position = Vector2(1180, 100)
		
		# Throw it UP (negative Y) and LEFT (negative X)
		var throw_x = randf_range(-200.0, -450.0) 
		var throw_y = randf_range(-200.0, -400.0)
		new_coin.linear_velocity = Vector2(throw_x, throw_y)

	# Connect the click signal and add to the scene
	new_coin.clicked.connect(_on_coin_clicked)
	add_child(new_coin)

func _on_coin_clicked() -> void:
	score += 1
	print("Coin collected! Score: ", score)
