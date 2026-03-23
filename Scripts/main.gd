extends Node2D

@onready var coin_scene: PackedScene = load(Global.SCENES.coin)
@onready var spawn_timer: Timer = $Timers/SpawnTimer
@onready var water_rect: ColorRect = $FountainPlaceholders/CanvasGroup/WaterIncrease

var score: int = 0 
var base_water_height: float = 0 
var floor_y_position: float = 360.0

var total_water_displacement: float = 0.0 

func _on_spawn_timer_timeout() -> void:
	spawn_coin()

func spawn_coin() -> void:
	if not coin_scene:
		return
	
	var new_coin = coin_scene.instantiate()
	var roll = randf()
	var random_key = "normal"
	
	if roll < 0.80: 
		random_key = "normal"
	elif roll < 0.95: 
		random_key = "heavy"
	else: 
		random_key = "bouncy"
		
	var selected_coin_data = Global.COIN_TYPES[random_key]
	
	new_coin.setup(selected_coin_data)
	
	var toss_side = randi() % 2
	if toss_side == 0:
		new_coin.position = Vector2(100, 100)
		new_coin.linear_velocity = Vector2(randf_range(200.0, 450.0), randf_range(-200.0, -400.0))
	else:
		new_coin.position = Vector2(1180, 100)
		new_coin.linear_velocity = Vector2(randf_range(-200.0, -450.0), randf_range(-200.0, -400.0))

	new_coin.clicked.connect(_on_coin_clicked)
	add_child(new_coin)

func _on_coin_clicked(clicked_coin: RigidBody2D) -> void:
	score += 1
	total_water_displacement -= clicked_coin.water_increase
	update_water_level()
	print("Coin collected! Score: ", score)

func update_water_level() -> void:
	var new_height = base_water_height + total_water_displacement
	
	water_rect.size.y = new_height
	water_rect.position.y = floor_y_position - new_height
	
	if water_rect.position.y <= 260.0:
		spawn_timer.stop()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Coins"):
		total_water_displacement += body.water_increase
		update_water_level()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Coins"):
		total_water_displacement -= body.water_increase
		update_water_level()
