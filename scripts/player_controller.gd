extends CharacterBody2D



@onready var assasinate_zone: Area2D = $AssasinateZone

#@export var table_sprite: Sprite2D
@export var speed: float = 400
@export var health: float = 10
@export var is_detected: bool = false
@export var melee_cooldown_time: float = 0.6

@onready var melee_area: Area2D = $"Melee/Weapon Pivot/Melee_Area"
@onready var melee_cooldown: Timer = $MeleeCooldown
var collected_fuel_tank: int = 0
var is_hiding: bool = false
var can_assasinate: bool = false
var is_in_hide_zone: bool = true
var is_attacking: bool = false


func _ready() -> void:
	melee_cooldown.wait_time = melee_cooldown_time
	melee_cooldown.one_shot   = true
	melee_cooldown.autostart  = false
	melee_cooldown.stop()

func _physics_process(_delta: float) -> void:
	if is_detected:
		handle_normal_movement()
		return
	
	if Input.is_action_just_pressed("melee_attack") and melee_cooldown.is_stopped():
		perform_melee_attack()
		
	
	if is_hiding:
		if Input.get_vector("move_left","move_right","move_up","move_down") != Vector2.ZERO:
			unhide()
			return
		if Input.is_action_just_pressed("assasinate"):
			check_for_assasination()
		return
	handle_normal_movement()
		
func handle_normal_movement():
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * speed
	move_and_slide()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hide") and is_in_hide_zone and not is_detected:
		if not is_hiding:	
			print("Hiding")
			hide_under_table()
		else:
			unhide()

func perform_melee_attack() -> void:
	is_attacking=true
	melee_cooldown.start()
	# Optional: Add animation or visual feedback here
	print("Player performs melee attack")
	
	var bodies = melee_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			body.take_damage(100)
			
	is_attacking = false

func unhide():
	is_hiding = false
	#table_sprite.modulate.a = 1.0
	print("Player is no longer hiding")

func hide_under_table():
	is_hiding = true
	can_assasinate = true
	#table_sprite.modulate.a = 0.4
	velocity = Vector2.ZERO
	print("Player is now hiding")

func check_for_assasination():
	if not can_assasinate and not is_hiding:
		return
	
	var enemies = assasinate_zone.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.is_in_group("enemy"):
			perform_assasination(enemy)
			break


func perform_assasination(enemy: Node2D):
	global_position = enemy.global_position
	# add enemy assasinating animation here
	enemy.queue_free()
	unhide()
	can_assasinate = false
	print("Enemy Assasinated")
	

func take_damage(damage:float):
	health -= damage
	# play hurt animation
	if health <= 0:
		# play animation of death
		print("YOU DIED")
		get_tree().reload_current_scene()
		
func on_detected_by_enemy():
	is_detected = true
	unhide()
	print("Player has been caught stealth disabled ")

func add_fuel():
	collected_fuel_tank += 1
	print("Collected Fuel : " , collected_fuel_tank)
