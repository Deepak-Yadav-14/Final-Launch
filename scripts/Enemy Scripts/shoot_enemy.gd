extends CharacterBody2D
class_name ShootingEnemy

@onready var ray_cast: RayCast2D = $Gun/RayCast
@onready var timer: Timer = $Timer
@export var Marker: Marker2D
@export var player: CharacterBody2D
@export var health: int = 10
@export var search_time: float = 10.0

var gun_rotation: float
var enemy_position: Vector2
var Marker_position: Vector2
var move_speed: float = 150.0
var search_rotation_speed: float = 1.0
var search_timer: float = 0.0
var player_in_range: bool = false
@onready var gun: Node2D = $Gun

const bullet = preload("res://scenes/Enemy Scenes/Enemy_bullet.tscn")

enum States {
    PATROLLING,
    FIGHTING,
    SEARCHING
}

var current_state = States.PATROLLING

func _ready() -> void:
    Marker_position = Marker.global_position
    gun_rotation = gun.global_rotation
    enemy_position = Marker_position
    print(enemy_position)

func _physics_process(delta: float) -> void:
    custome_process(delta)

func custome_process(delta: float) -> void:
    if player_in_range:
        ray_cast.target_position = gun.to_local(player.global_position)
        ray_cast.force_raycast_update()
        if ray_cast.is_colliding():
            #print(ray_cast.get_collider())
            var collider = ray_cast.get_collider()
            if collider.is_in_group("Hurt_Detector"):
                print("hit")
                var target = collider.get_parent()
                if target == player and current_state != States.FIGHTING:
                    current_state = States.FIGHTING

    match current_state:
        States.FIGHTING:
            var to_player = player.global_position - gun.global_position
            var target_angle = to_player.angle()
            gun.rotation = lerp_angle(gun.rotation, target_angle, 5 * delta)

            ray_cast.target_position = gun.to_local(player.global_position)
            ray_cast.force_raycast_update()

            if ray_cast.is_colliding():
                var collider = ray_cast.get_collider()
                if collider.is_in_group("Hurt_Detector") and collider.get_parent() == player:
                    if timer.is_stopped():
                        timer.start()
                else:
                    if not timer.is_stopped():
                        timer.stop()

            velocity = Vector2.ZERO


        States.SEARCHING:
            gun.rotation += search_rotation_speed * delta
            search_timer -= delta
            if search_timer <= 0:
                current_state = States.PATROLLING
            velocity = Vector2.ZERO

        #States.PATROLLING:
            #var distance_to_target = global_position.distance_to(enemy_position)
            #if distance_to_target > 1.0:
                #var target = enemy_position - global_position
                #var return_angle = target.angle() 
                #gun.rotation = lerp_angle(gun.rotation, return_angle, 5 * delta)
                #velocity = target.normalized() * move_speed
            #else:
                #gun.rotation = lerp_angle(gun.rotation, gun_rotation, 0.1)
                #velocity = Vector2.ZERO

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
        if not timer.is_stopped():
            timer.stop()

func _on_timer_timeout() -> void:
    shoot()

func shoot() -> void:
    var ammo = bullet.instantiate()
    ammo.position = gun.global_position
    var to_player = (player.global_position - gun.global_position).normalized()
    ammo.direction = to_player
    get_tree().current_scene.add_child(ammo)

func take_damage(value):
    health -= value
    if health <= 0:
        print("Enemy Dies")
        queue_free()
