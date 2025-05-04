extends Node2D

@onready var gun_right: Sprite2D = $"Weapon Pivot/Gun Right"
@onready var gun_left: Sprite2D = $"Weapon Pivot/Gun Left"
@onready var gun_up: Sprite2D = $"Weapon Pivot/Gun Up"
@onready var gun_down: Sprite2D = $"Weapon Pivot/Gun Down"
@onready var shoot_point: Marker2D = $"Weapon Pivot/Shoot Point"

@export var fire_rate:float = 0.2

const BULLET = preload("res://scenes/Bullet.tscn")

var time_since_last_shot: float = 0.0

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var to_mouse = (mouse_pos - global_position).normalized()
	var angle = to_mouse.angle()
	
	rotation = angle
	
	gun_right.visible = false;
	gun_left.visible = false;
	gun_up.visible = false;
	gun_down.visible = false;
	
	var deg = rad_to_deg(angle)
	deg = fposmod(deg,360)
	
	if deg >= 45 and deg < 135:
		gun_down.visible = true
	elif deg >= 135 and deg < 225:
		gun_left.visible = true
	elif deg >= 225 and deg < 315:
		gun_up.visible = true
	else:
		gun_right.visible = true
	
	time_since_last_shot += delta
	if Input.is_action_pressed("shoot") and time_since_last_shot >= fire_rate:
		#shoot_bullet(to_mouse)
		
		time_since_last_shot = 0.0
		
func shoot_bullet(direction: Vector2):
	var bullet = BULLET.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = shoot_point.global_position
	bullet.rotation = direction.angle()
