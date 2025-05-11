extends Node2D

@onready var dialogbox: Control = %Dialogbox

func _ready() -> void:
    var dialog_lines: Array[String] = ["Whew... it's done. The gun’s finally working.", "Now... all that's left is to escape this godforsaken place.", "No more hiding. No more running. It's do or die."]
    dialogbox.show_dialog(dialog_lines)



func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.name == "Player":
        get_tree().change_scene_to_file("res://scenes/Levels/overworld.tscn")
