extends StaticBody2D

@onready var label: Label = $Label
@onready var dialogbox: Control = %Dialogbox
@onready var burst_animation: AnimationPlayer = $"Burst Animation"


var keyboard: bool = false
var is_entered: bool = false
@export var player: CharacterBody2D
var total_fuel_required: int = 100

func _process(delta: float) -> void:
    if is_entered:
        if keyboard and Input.is_action_just_pressed("Interaction"):
            dialogbox.visible = true
            var dialog_lines: Array[String] = ["Hmmm...... I need Fuel for the rocket", "Total Fuel :- " + str(player.collected_fuel_tank) + "/" + str(total_fuel_required) + "."]
            dialogbox.show_dialog(dialog_lines)
            if player.collected_fuel_tank >= total_fuel_required:
                dialog_lines = ["Well....Now I have enough fuel for the take off.", "See you (I hope not) folks of this planet."]
                dialogbox.show_dialog(dialog_lines)
                #play the animation
                player.visible = false
                player.get_child(0)
                burst_animation.play("Burst animation")
        
                
func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.name == "Player":
        player = body
        is_entered = true
        keyboard = true
        label.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
    if body.name == "Player":
        is_entered = false
        keyboard = false
        label.visible = false

func _on_burst_animation_animation_finished(anim_name: StringName) -> void:
    get_tree().change_scene_to_file("res://scenes/UI/game_complete.tscn")
