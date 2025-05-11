extends AudioStreamPlayer2D

@onready var audio_listener_2d: AudioStreamPlayer2D = $"."


func _on_finished() -> void:
    audio_listener_2d.play()
