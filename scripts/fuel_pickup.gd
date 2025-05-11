extends Area2D

@export var lifetime: float = 20
@onready var collect: AudioStreamPlayer2D = $collect

var time_span: float = 0

func _process(delta: float) -> void:
    time_span += delta
    if time_span >= lifetime:
        call_deferred("queue_free")
        time_span=0;

func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		body.add_fuel()
		collect.play()
		


func _on_collect_finished() -> void:
	queue_free()
