extends StaticBody2D

func _on_hide_zone_body_entered(body: Node2D) -> void:
	# it means the player is under the table
	if body.name == "Player":
		body.is_in_hide_zone = true
		body.can_assasinate = true


func _on_hide_zone_body_exited(body: Node2D) -> void:
	# it means player exits the table
	if body.name == "Player":
		body.is_in_hide_zone = false
		body.can_assasinate = false
