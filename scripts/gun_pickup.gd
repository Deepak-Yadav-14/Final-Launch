extends Area2D

@export var Gun: PackedScene  # Assign your weapon scene (e.g. Gun.tscn) in the editor

func _on_GunPickup_body_entered(body: Node) -> void:
	# Only proceed if the colliding body is in the "Player" group
	if body.is_in_group("Player"):
		# Instantiate the new weapon and hand it to the player
		var new_weapon = Gun.instantiate()
		body.pick_up_weapon(new_weapon)
		# Remove the pickup from the scene
		queue_free()
