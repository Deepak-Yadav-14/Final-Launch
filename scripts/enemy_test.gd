extends CharacterBody2D

@onready var ray_cast: RayCast2D = $RayCast
@onready var timer: Timer = $Timer
@export var bullet: PackedScene
@export var player: CharacterBody2D
@export var health: int = 10

var player_entered = false

enum States{
	PETROLLING,
	FIGHTING
}

var current_state = States.PETROLLING

func _physics_process(_delta: float) -> void:
	if player_entered:
		var to_player = player.global_position - global_position
		rotation = to_player.angle() - PI / 2
		aim(player)
		check_player_collision(player)
	else:
		pass

func check_player_collision(player) -> void:
	if ray_cast.get_collider() == player and timer.is_stopped():
		timer.start()
	elif ray_cast.get_collider() != player and not timer.is_stopped():
		timer.stop()
	elif ray_cast.get_collider() != player and timer.is_stopped():
		timer.stop()

func _on_visiblity_body_entered(body: Node2D) -> void:
	if body == player:
		current_state = States.FIGHTING
		player_entered = true
	else:
		pass

func _on_visiblity_body_exited(body: Node2D) -> void:
	player_entered = false
	if not timer.is_stopped():
		timer.stop()

func aim(player) -> void:
	ray_cast.target_position = to_local(player.position)

func _on_timer_timeout() -> void:
	shoot()

func shoot() -> void:
	var ammo = bullet.instantiate()
	ammo.position = global_position
	var to_player = (player.global_position - global_position).normalized()
	ammo.direction = to_player
	get_tree().current_scene.add_child(ammo)

func petrolling(delta):
	pass

func take_damage(amount):
	health -= amount
	if health <= 0:
		print("Enemie Dies")
		die()


func die() -> void:
	queue_free()
	print("Enemy defeated")
