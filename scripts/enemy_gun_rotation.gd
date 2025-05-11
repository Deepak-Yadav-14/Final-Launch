extends Node2D

@onready var gun_left: Sprite2D = $"Weapon Pivot/Gun Left"
@onready var gun_right: Sprite2D = $"Weapon Pivot/Gun Right"
@onready var hand_right_2: Node2D = $"Weapon Pivot/Hand Right2"
@onready var hand_left_2: Node2D = $"Weapon Pivot/Hand Left2"
@onready var hand_right: Node2D = $"Weapon Pivot/Hand Right"
@onready var hand_left: Node2D = $"Weapon Pivot/Hand Left"


func _process(delta: float) -> void:
	gun_right.visible = false;
	gun_left.visible = false;
	hand_left_2.visible = false;
	hand_right_2.visible = false;
	hand_left.visible = false;
	hand_right.visible = false;
	
	# Flip torso based on gun aim direction
	
	if cos(rotation) < 0:
		
		position.x = 17
		gun_left.visible = true
		hand_left_2.visible = true
		hand_right_2.visible = true
		
		
	else:
		position.x = -13
		gun_right.visible = true
		hand_left.visible = true
		hand_right.visible = true
