extends RigidBody2D

signal clicked(coin_node) 

var water_increase: float = 0.0

func setup(coin_data: Dictionary) -> void:
	mass = coin_data["weight"]
	scale = coin_data["scale"]
	var phys_mat = PhysicsMaterial.new() # this thing is used for adding physics properties for a material
	phys_mat.bounce = coin_data["bounce"]
	phys_mat.friction = coin_data["friction"]
	physics_material_override = phys_mat
	
	water_increase = coin_data["water_increase"]
	
	$Sprite2D.modulate = coin_data["color"]

func wake_up() -> void:
	sleeping = false

func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("clicked", self) 
		get_tree().call_group("Coins", "wake_up")
		queue_free()
