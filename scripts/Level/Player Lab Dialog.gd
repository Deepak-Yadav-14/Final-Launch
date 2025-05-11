extends Dialog

func _ready() -> void:
    queue_dialog("hello")
    queue_dialog("bye")
    hide_text_box()
