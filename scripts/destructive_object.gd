extends Area2D

const FUEL_PICKUP = preload("res://scenes/FuelPickup.tscn")

@export var fuel_Count:int = 3
@onready var timer: Timer = $Timer
@export var health: int = 3
@onready var crate: Sprite2D = $Crate
@onready var crate_break: Sprite2D = $"Crate break"
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var collision: CollisionShape2D = $StaticBody2D/Collision

func take_damage(amount):
    health -= amount
    if health <= 0:
        crate.visible = false
        explosion.play()
        
    
    
func break_apart():
    _spawn_fuel()
    #call_deferred("queue_free")
        
func _spawn_fuel(_anim_name=""):
    for i in range(fuel_Count):
        var fuel = FUEL_PICKUP.instantiate()
        var angle = randf() * TAU
        var distance = randf_range(8.0, 24.0)
        fuel.position = global_position + Vector2(cos(angle), sin(angle)) * distance
        get_parent().call_deferred("add_child",fuel)
    

func _on_explosion_animation_finished() -> void:
    crate_break.visible = true
    collision.disabled = true
    break_apart()
    timer.start()


func _on_timer_timeout() -> void:
    queue_free()
