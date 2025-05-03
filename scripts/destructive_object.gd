extends Area2D

const FUEL_PICKUP = preload("res://scenes/FuelPickup.tscn")

@export var fuel_Count:int = 3

#@onready var anim: AnimationPlayer = $RigidBody2D/AnimationPlayer
#const BREAK_ANIM: String = "break"

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT :
		_break_apart()  # Replace with function body.


func _on_body_entered(body):
	if body:
		body.queue_free()
		_break_apart()
	
	
func _break_apart():
	_spawn_fuel()
		
func _spawn_fuel(_anim_name=""):
	for i in range(fuel_Count):
		var fuel = FUEL_PICKUP.instantiate()
		var angle = randf() * TAU
		var distance = randf_range(8.0, 24.0)
		fuel.position = global_position + Vector2(cos(angle), sin(angle)) * distance
		get_parent().add_child(fuel)
	queue_free()
	
