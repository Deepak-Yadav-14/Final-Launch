extends StaticBody2D



func _on_hide_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.is_in_hide_zone = true


func _on_hide_zone_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		body.is_in_hide_zone = false
