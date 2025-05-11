extends StaticBody2D

@onready var door_animation: AnimatedSprite2D = $"Door Animation"
@onready var door_collision: CollisionShape2D = $"Door Collision"
@onready var label: Label = $Label
@onready var electric_door: StaticBody2D = $"."

var keyboard: bool = false
var is_entered: bool = false
var door_opened: bool = false

func _process(delta: float) -> void:
	if is_entered and !door_opened:
		if keyboard == true and Input.is_action_just_pressed("Interaction"):
			electric_door.z_index = 1
			door_animation.play()
			door_opened = true

func _on_area_input_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if !door_opened:
			is_entered = true
			label.visible = true
			keyboard = true


func _on_area_input_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		if !door_opened:
			is_entered = false
			label.visible = false
			keyboard = false
		elif door_opened:
			label.visible = false


func _on_door_animation_animation_finished() -> void:
	door_collision.disabled = true
