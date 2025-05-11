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
    
    
func _on_area_entered(area):
    if area.is_in_group("destructible"):
        # Implement take damage function for each enemy or destructible object
        area.take_damage(1)
    queue_free()
    
func _on_body_entered(body):
    if body.is_in_group("enemy"):
        # Implement take damage function for each enemy or destructible object
        
        body.take_damage(1)
    queue_free() 
