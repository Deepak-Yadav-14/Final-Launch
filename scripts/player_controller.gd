extends CharacterBody2D


@onready var assasinate_zone: Area2D = $AssasinateZone
#@onready var melee_area: Area2D = $"Melee"
#@onready var melee_cooldown: Timer = $MeleeCooldown
@onready var animation_player: AnimationPlayer = $Torso/AnimationPlayer

#@export var table_sprite: Sprite2D
@export var speed: float = 400
@export var crouch_speed_factor: float = 0.5
@export var health: float = 10
@export var is_detected: bool = false
@export var melee_cooldown_time: float = 0.6


var collected_fuel_tank: int = 100

var is_attacking: bool = false
var is_in_hide_zone: bool = false
var is_crouching: bool = false
var can_assasinate: bool = false
var curr_speed: float = speed
var current_weapon: Node2D = null


func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	# Basic Movement Logic
	if not current_weapon:
		var temp = %"Torso"
		temp.get_node("Hand Left").visible = true 
		temp.get_node("Hand Right").visible = true
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var base_scale_x = abs($"Torso".scale.x)
	if (direction.x < 0):
		$"Torso".scale.x = - base_scale_x
	elif (direction.x > 0):
		$"Torso".scale.x = base_scale_x

	
	velocity = direction * curr_speed
	move_and_slide()
	
	_update_animation(direction)
	# Basic Crouch Mechanic
	if Input.is_action_pressed("crouch"):
		if not is_crouching:
			is_crouching = true
			curr_speed = speed * crouch_speed_factor
			set_collision_mask_value(2, false)
	else:
		# if player is under the table and exits it
		if not is_in_hide_zone:
			if not is_crouching:
				set_collision_mask_value(2, true)
			else:
				is_crouching = false
				curr_speed = speed
			
	if is_in_hide_zone:
		if current_weapon != null:
			%"Gun".visible = false
		if Input.is_action_just_pressed("assasinate"):
			print("Hello")
			check_for_assasination()
		return
	
	#if Input.is_action_just_pressed("melee_attack") and melee_cooldown.is_stopped():
		#perform_melee_attack()
		
		
func _update_animation(input_vec: Vector2) -> void:
	if is_crouching:
		if input_vec.length() > 0:
			#animation_player.play("crouch_run")
			pass
		else:
			#animation_player.play("crouch_idle")
			pass
	else:
		if input_vec.length() > 0:
			animation_player.play("player_run")
		else:
			animation_player.play("player_idle")
#func perform_melee_attack() -> void:
	#is_attacking=true
	#melee_cooldown.start()
	## Optional: Add animation or visual feedback here
	#
	#print("Player performs melee attack")
	#
	#var bodies = melee_area.get_overlapping_bodies()
	#var objects =  melee_area.get_overlapping_areas() 
	#print(bodies)
	#
	#for body in bodies:
		#if body.is_in_group("enemy") or body.is_in_group("destructible") :
			#print("Enemy Detected")
			#body.take_damage(100)
	#for area in objects:
		#if area.is_in_group("destructible") :
			#print("Object Detected")
			#area.take_damage(100)
	#
	#is_attacking = false

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
	
func pick_up_weapon(weapon: Node) -> void:
	# Remove any existing weapon in the slot
	if current_weapon:
		current_weapon.queue_free()
	# Attach the new weapon and reset its position
	add_child(weapon)
	var temp = %"Torso"
	temp.get_node("Hand Left").visible = false
	temp.get_node("Hand Right").visible = false
	
	current_weapon = weapon
	# (Optional: you could initialize weapon-specific logic here)

func take_damage(damage: float) -> void:
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
	print("Collected Fuel : ", collected_fuel_tank)


func _on_hurt_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hurt_Zone"):
		take_damage(area.bullet_damage)
		area.queue_free()
