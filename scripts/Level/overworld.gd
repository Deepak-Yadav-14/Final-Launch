extends Node2D

@onready var dialogbox: Control = $Dialogbox2


func _ready() -> void:
    dialogbox.visible = true
    var dialog_lines: Array[String] = ["I am finally out!","Now I need to find that rocket."]
    dialogbox.show_dialog(dialog_lines)
