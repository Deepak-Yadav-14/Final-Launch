extends CharacterBody2D

var collected_fuel_tank: int = 0

@export var speed: float = 400

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * speed
	move_and_slide()


func add_fuel():
	collected_fuel_tank += 1
	print("Collected Fuel : " , collected_fuel_tank)
