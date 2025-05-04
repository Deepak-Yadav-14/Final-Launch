extends Area2D

@export var time_span:int = 0

func _process(delta: float) -> void:
	time_span += 1 + delta
	if time_span >= 1000:
		call_deferred("queue_free")
		time_span=0;

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.add_fuel()
		queue_free()
