extends Area2D

@export var bullet_speed:float = 1500
@export var bullet_range:float = 1200
@export var bullet_damage:float = 1

var travelled_distance:float = 0;
var direction = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	direction = direction.rotated(rotation)
	position += direction * bullet_speed * delta
	travelled_distance += bullet_speed * delta
	
	if travelled_distance > bullet_range:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(bullet_damage)
	queue_free() 
