extends Area2D

@onready var gun_right: Area2D = $"Weapon Pivot/Gun Right"
@onready var gun_left: Area2D = $"Weapon Pivot/Gun Left"
@onready var gun_up: Area2D = $"Weapon Pivot/Gun Up"
@onready var gun_down: Area2D = $"Weapon Pivot/Gun Down"
@onready var anim: AnimationPlayer = $AnimationPlayer
@export var fire_rate:float = 0.2
@onready var melee_cooldown: Timer = $MeleeCooldown
@export var melee_cooldown_time: float = 0.6

const BULLET = preload("res://scenes/Bullet.tscn")
var current_visible:Area2D = gun_right
var is_attacking: bool = false
var time_since_last_shot: float = 0.0

func _ready() -> void:
	melee_cooldown.wait_time = melee_cooldown_time
	melee_cooldown.one_shot  = true
	melee_cooldown.autostart  = false
	melee_cooldown.stop()

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
		current_visible=gun_down
	elif deg >= 135 and deg < 225:
		gun_left.visible = true
		current_visible = gun_left
	elif deg >= 225 and deg < 315:
		gun_up.visible = true
		current_visible = gun_up
	else:
		gun_right.visible = true
		current_visible = gun_right
	
	time_since_last_shot += delta
	#if Input.is_action_pressed("melee_attack"):
		#melee_attack(to_mouse)
		#
		#time_since_last_shot = 0.0
		#
#func melee_attack(direction: Vector2):
	##var bullet = BULLET.instantiate()
	##get_tree().current_scene.add_child(bullet)
	##bullet.global_position = shoot_point.global_position
	##bullet.rotation = direction.angle()
	#anim.play("Attack")
func perform_melee_attack() -> void:
	if not melee_cooldown.is_stopped():
		return
	is_attacking=true
	melee_cooldown.start()
	# Optional: Add animation or visual feedback here
	#anim.play("Attack")
	print("Player performs melee attack")
	
	var bodies = current_visible.get_overlapping_bodies()
	var objects =  current_visible.get_overlapping_areas() 
	print(bodies)
	print(objects)
	for body in bodies:
		if body.is_in_group("enemy") or body.is_in_group("destructible") :
			print("Enemy Detected")
			body.take_damage(100)
	for area in objects:
		if area.is_in_group("destructible") :
			print("Object Detected")
			area.take_damage(100)
	
	is_attacking = false
