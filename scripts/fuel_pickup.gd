extends Area2D

@export var lifetime: float = 20

var time_span: float = 0

func _process(delta: float) -> void:
    time_span += delta
    if time_span >= lifetime:
        call_deferred("queue_free")
        time_span=0;

func _on_body_entered(body) -> void:
    if body.is_in_group("Player"):
        body.add_fuel()
        queue_free()
