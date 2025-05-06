extends CharacterBody2D
class_name ShootingEnemy

@onready var ray_cast: RayCast2D = $RayCast
@onready var timer: Timer = $Timer
@export var player: CharacterBody2D
@export var health: int = 10
@onready var player_rotation: float

var player_entered = false

enum States{
    PETROLLING,
    FIGHTING
}

var current_state = States.PETROLLING

const bullet = preload("res://scenes/Enemy Scenes/Enemy_bullet.tscn")

func _ready() -> void:
    player_rotation = rotation

func custome_process(delta: float) -> void:
    if player_entered:
        #var to_player = player.global_position - global_position
        var target_angle = (player.global_position - global_position).angle() - PI / 2
        rotation = lerp_angle(rotation, target_angle, 5 * delta)
        aim(player)
        check_player_collision(player)

func _physics_process(delta: float) -> void:
    if current_state == States.PETROLLING and rotation != player_rotation:
        rotation = lerp_angle(rotation, player_rotation, 0.1)
    custome_process(delta)

func check_player_collision(player) -> void:
    if ray_cast.get_collider() == player and timer.is_stopped():
        timer.start()
    elif ray_cast.get_collider() != player and not timer.is_stopped():
        timer.stop()

func _on_visiblity_body_entered(body: Node2D) -> void:
    if body == player:
        current_state = States.FIGHTING
        player_entered = true

func _on_visiblity_body_exited(body: Node2D) -> void:
    player_entered = false
    current_state = States.PETROLLING
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

func take_damage(value):
    health -= value
    if health <= 0:
        print("Enemie Dies")
        queue_free()
