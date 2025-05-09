extends CharacterBody2D


@onready var assasinate_zone: Area2D = $AssasinateZone
@onready var melee_area: Area2D = $"Melee"
@onready var anim: AnimationPlayer = $"Melee/AnimationPlayer"

#@export var table_sprite: Sprite2D
@export var speed: float = 400
@export var crouch_speed_factor: float = 0.5
@export var health: float = 10
@export var is_detected: bool = false


var collected_fuel_tank: int = 0

var is_attacking: bool = false
var is_in_hide_zone: bool = false
var is_crouching: bool = false
var can_assasinate: bool = false
var curr_speed: float  = speed

#func _ready() -> void:
	#melee_cooldown.wait_time = melee_cooldown_time
	#melee_cooldown.one_shot  = true
	#melee_cooldown.autostart  = false
	#melee_cooldown.stop()

func _physics_process(_delta: float) -> void:
	# Basic Movement Logic
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * curr_speed
	move_and_slide()
	
	# Basic Crouch Mechanic
	if Input.is_action_pressed("crouch"):
		if not is_crouching:
			is_crouching = true
			curr_speed = speed * crouch_speed_factor
			set_collision_mask_value(2,false)
	else:
		# if player is under the table and exits it
		if not is_in_hide_zone:
			if not is_crouching:
				set_collision_mask_value(2,true)
			else:
				is_crouching = false
				curr_speed = speed
			
	if is_in_hide_zone:
		%"Gun".visible = false
		if Input.is_action_just_pressed("assasinate"):
			check_for_assasination()
		return
	else:
		%"Gun".visible = true	
		
	if Input.is_action_just_pressed("melee_attack")  :
		anim.play("Attack")
		


func check_for_assasination() -> void:
	if not can_assasinate and not is_in_hide_zone:
		return
	
	var enemies = assasinate_zone.get_overlapping_bodies()
	print(enemies)
	for enemy in enemies:
		if enemy.is_in_group("enemy"):
			perform_assasination(enemy)
			break


func perform_assasination(enemy: Node2D) -> void:
	global_position = enemy.global_position
	# add enemy assasinating animation here
	enemy.queue_free()
	print("Enemy Assasinated")
	

func take_damage(damage:float) -> void:
	health -= damage
	# play hurt animation
	if health <= 0:
		# play animation of death
		print("YOU DIED")
		get_tree().reload_current_scene()
		
func on_detected_by_enemy() -> void:
	is_detected = true
	print("Player has been caught stealth disabled ")

func add_fuel() -> void:
	collected_fuel_tank += 1
	print("Collected Fuel : " , collected_fuel_tank)
