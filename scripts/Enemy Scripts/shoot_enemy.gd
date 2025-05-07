extends CharacterBody2D
class_name ShootingEnemy

@onready var ray_cast: RayCast2D = $RayCast
@onready var timer: Timer = $Timer
@onready var Marker: Marker2D = %ShootMarker

@export var player: CharacterBody2D
@export var health: int = 10
@export var search_time: float = 10.0

var enemy_rotation: float
var enemy_position: Vector2
var Marker_position: Vector2

var move_speed: float = 100.0
var search_rotation_speed: float = 1.0  
var search_timer: float = 0.0
var player_rotation

const bullet = preload("res://scenes/Enemy Scenes/Enemy_bullet.tscn")

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
    match current_state:
        States.FIGHTING:
            var to_player = player.global_position - global_position
            var target_angle = to_player.angle() - PI / 2
            rotation = lerp_angle(rotation, target_angle, 5 * delta)

            ray_cast.target_position = to_local(player.position)

            if ray_cast.get_collider() == player:
                if timer.is_stopped():
                    timer.start()
            else:
                if not timer.is_stopped():
                    timer.stop()
                    
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
        if current_state == States.PATROLLING or current_state == States.SEARCHING:
            current_state = States.FIGHTING

func _on_visiblity_body_exited(body: Node2D) -> void:
    if body == player and current_state == States.FIGHTING:
        current_state = States.SEARCHING
        search_timer = search_time
        if not timer.is_stopped():
            timer.stop()

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
        print("Enemy Dies")
        queue_free()
