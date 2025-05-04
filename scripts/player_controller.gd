extends CharacterBody2D

var collected_fuel_tank: int = 0

@export var speed: float = 400
@export var health: float = 10

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * speed
	move_and_slide()


func take_damage(damage:float):
	health -= damage
	# play hurt animation
	if health <= 0:
		# play animation of death
		print("YOU DIED")
		get_tree().reload_current_scene()

func add_fuel():
	collected_fuel_tank += 1
	print("Collected Fuel : " , collected_fuel_tank)
