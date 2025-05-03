extends Area2D
#
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.add_fuel(1)
	#queue_free()
