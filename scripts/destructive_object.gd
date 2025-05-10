extends Area2D

const FUEL_PICKUP = preload("res://scenes/FuelPickup.tscn")

@export var fuel_Count:int = 3

@export var health: int = 3
#@onready var anim: AnimationPlayer = $RigidBody2D/AnimationPlayer
#const BREAK_ANIM: String = "break"

func take_damage(amount):
    health -= amount
    print("damage_happens")
    # Details can be added after each hit
    if health <= 0:
        # Add destroying animation than add the queue free in that animation
        break_apart()
    
    
func break_apart():
    _spawn_fuel()
    call_deferred("queue_free")
        
func _spawn_fuel(_anim_name=""):
    for i in range(fuel_Count):
        var fuel = FUEL_PICKUP.instantiate()
        var angle = randf() * TAU
        var distance = randf_range(8.0, 24.0)
        fuel.position = global_position + Vector2(cos(angle), sin(angle)) * distance
        get_parent().call_deferred("add_child",fuel)
    
