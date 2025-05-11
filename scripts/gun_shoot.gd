extends Node2D
@onready var weapon_pivot: Marker2D = $"Weapon Pivot"

@onready var gun_right: Sprite2D = $"Weapon Pivot/Gun Right"
@onready var gun_left: Sprite2D = $"Weapon Pivot/Gun Left"
@onready var shoot_point: Marker2D = $"Weapon Pivot/Shoot Point"
@onready var hand_right: Node2D = $"Weapon Pivot/Hand Right"
@onready var hand_left: Node2D = $"Weapon Pivot/Hand Left"
@onready var hand_left_2: Node2D = $"Weapon Pivot/Hand Left2"
@onready var hand_right_2: Node2D = $"Weapon Pivot/Hand Right2"
@onready var bullet_sound: AudioStreamPlayer2D = $"../bullet sound"

@export var fire_rate:float = 0.2

const BULLET = preload("res://scenes/Bullet.tscn")

var time_since_last_shot: float = 0.0

func _process(delta: float) -> void:

    if not is_visible_in_tree():
        return
    var mouse_pos = get_global_mouse_position()
    var to_mouse = (mouse_pos - global_position).normalized()
    var angle = to_mouse.angle()
    
    rotation = angle
    
    gun_right.visible = false;
    gun_left.visible = false;
    hand_left_2.visible = false;
    hand_right_2.visible = false;
    hand_left.visible = false;
    hand_right.visible = false;
    
    var deg = rad_to_deg(angle)
    deg = fposmod(deg,360)
    
    
    
    if deg >= 90 and deg < 270:
        # HARD CODED FOR HAND PLACEMENT
        position.x = 32
        ###
        gun_left.visible = true
        hand_left_2.visible = true
        hand_right_2.visible = true
    else:
        position.x = -26
        gun_right.visible = true
        hand_left.visible = true
        hand_right.visible = true
    
    time_since_last_shot += delta
    if Input.is_action_pressed("shoot") and time_since_last_shot >= fire_rate:
        bullet_sound.play()
        shoot_bullet(to_mouse)
        time_since_last_shot = 0.0
        
func shoot_bullet(direction: Vector2):
	var bullet = BULLET.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = shoot_point.global_position
	bullet.rotation = direction.angle()
