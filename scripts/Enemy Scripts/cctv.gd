extends CharacterBody2D

@onready var ray_cast: RayCast2D = $RayCast
@export var player: CharacterBody2D
@export var health: int = 10
@export var search_time: float = 10.0
@export var rotation_speed: float = 1.0 
@export_range(-90, 0, 1) var min_angle: float = -45.0
@export_range(0, 90, 1) var max_angle: float = 45.0

var base_rotation: float
var min_rotation: float
var max_rotation: float
var direction := 1 
var enemy_rotation: float
var enemy_position: Vector2
var move_speed: float = 250.0
var search_rotation_speed: float = 1.0
var search_timer: float = 0.0
var player_in_range: bool = false

enum States {
    PATROLLING,
    FIGHTING,
    SEARCHING
}

var current_state = States.PATROLLING

func _ready() -> void:
    enemy_rotation = global_rotation
    base_rotation = rotation
    min_rotation = deg_to_rad(min_angle)
    max_rotation = deg_to_rad(max_angle)


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
            var to_player = player.global_position - global_position
            var target_angle = to_player.angle() - PI / 2
            rotation = lerp_angle(rotation, target_angle, 5 * delta)
            ray_cast.target_position = to_local(player.position)
        States.SEARCHING:
            velocity = Vector2.ZERO
            search_timer -= delta
            if search_timer <= 0:
                current_state = States.PATROLLING
        States.PATROLLING:
            rotation += direction * rotation_speed * delta
            var relative_rotation = rotation - base_rotation
            if relative_rotation > max_rotation:
                rotation = base_rotation + max_rotation
                direction = -1
            elif relative_rotation < min_rotation:
                rotation = base_rotation + min_rotation
                direction = 1
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
