extends CharacterBody2D

@onready var ray_cast: RayCast2D = $RayCast
@export var player: CharacterBody2D
@export var health: int = 10
@export var search_time: float = 10.0
@onready var Marker: Marker2D = %Marker2D
@onready var timer: Timer = $Timer

var enemy_rotation: float
var enemy_position: Vector2
var Marker_position: Vector2
var move_speed: float = 250.0
var search_rotation_speed: float = 1.0
var search_timer: float = 0.0
var player_in_range: bool = false
var can_attack: bool = false

enum States {
	PATROLLING,
	FIGHTING,
	SEARCHING
}

var current_state = States.PATROLLING

func _ready() -> void:
	Marker_position = Marker.global_position
	enemy_rotation = global_rotation
	enemy_position = Marker_position
	print(enemy_position)

func _physics_process(delta: float) -> void:
	custome_process(delta)

func custome_process(delta: float) -> void:
	if player_in_range:
		ray_cast.target_position = to_local(player.global_position)
		ray_cast.force_raycast_update()
		if ray_cast.is_colliding() and ray_cast.get_collider() == player:
			if current_state != States.FIGHTING:
				current_state = States.FIGHTING

	match current_state:
		States.FIGHTING:
			if !can_attack:
				var to_player = player.global_position - global_position
				var target_angle = to_player.angle() - PI / 2
				rotation = lerp_angle(rotation, target_angle, 5 * delta)
				ray_cast.target_position = to_local(player.position)
				if ray_cast.get_collider() == player:
					velocity = to_player.normalized() * move_speed
				else:
					velocity = Vector2.ZERO
			elif can_attack:
				velocity = Vector2.ZERO
		States.SEARCHING:
			rotation += search_rotation_speed * delta
			search_timer -= delta
			if search_timer <= 0:
				current_state = States.PATROLLING
			velocity = Vector2.ZERO
		States.PATROLLING:
			var distance_to_target = global_position.distance_to(enemy_position)
			if distance_to_target > 1.0:
				var target = enemy_position - global_position
				var return_angle = target.angle() - PI / 2
				rotation = lerp_angle(rotation, return_angle, 5 * delta)
				velocity = target.normalized() * move_speed
			else:
				rotation = lerp_angle(rotation, enemy_rotation, 0.1)
				velocity = Vector2.ZERO
	move_and_slide()

func _on_visiblity_body_entered(body: Node2D) -> void:
	if body == player:
		player_in_range = true


func _on_visiblity_body_exited(body: Node2D) -> void:
	if body == player:
		player_in_range = false
		if current_state == States.FIGHTING:
			current_state = States.SEARCHING
			search_timer = search_time

func take_damage(value):
	health -= value
	if health <= 0:
		print("Enemy Dies")
		queue_free()

func attack_player(body) -> void:
	body.take_damage(1)

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body == player:
		can_attack = true
		timer.start()

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body == player:
		can_attack = false
		timer.stop()


func _on_timer_timeout() -> void:
	attack_player(player)
