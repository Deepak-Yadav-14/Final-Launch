extends StaticBody2D

@onready var label: Label = $Label
@onready var cctv_2: CharacterBody2D = %CCTV2
@onready var cctv_4: CharacterBody2D = %CCTV4
@onready var cctv_5: CharacterBody2D = %CCTV5
@onready var cctv_3: CharacterBody2D = %CCTV3

var keyboard: bool = false
var is_entered: bool = false
var generator_off: bool = false

func _process(delta: float) -> void:
    if is_entered and !generator_off:
        if keyboard == true and Input.is_action_just_pressed("Interaction"):
            cctv_2.queue_free()
            cctv_3.queue_free()
            cctv_4.queue_free()
            cctv_5.queue_free()
            generator_off = true

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.name == "Player":
        if !generator_off:
            is_entered = true
            label.visible = true
            keyboard = true


func _on_area_2d_body_exited(body: Node2D) -> void:
    if body.name == "Player":
        if !generator_off:
            is_entered = false
            label.visible = false
            keyboard = false
