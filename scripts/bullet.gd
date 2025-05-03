extends Area2D

@export var bullet_speed:float = 1000
@export var bullet_range:float = 1200

var travelled_distance:float = 0;

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * bullet_speed * delta
	travelled_distance += bullet_speed * delta
	
	if travelled_distance > bullet_range:
		queue_free()
	
	
	 
