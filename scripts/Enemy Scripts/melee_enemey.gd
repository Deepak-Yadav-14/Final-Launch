extends CharacterBody2D

@onready var ray_cast: RayCast2D = $RayCast
@export var player: CharacterBody2D
@export var health: int = 10
@onready var Marker: Marker2D = %Marker2D

var enemy_rotation: float
var enemy_position
var Marker_position
var Marker_rotation
var player_entered = false
var move_speed: float = 200.0

enum States{
    PETROLLING,
    FIGHTING
}

var current_state = States.PETROLLING

func _ready() -> void:
    Marker_position = Marker.global_position
    Marker_rotation = Marker.rotation
    enemy_rotation = global_rotation
    enemy_position = Marker_position
    print(enemy_position)

func custome_process(delta: float) -> void:
    if player_entered:
        var to_player = player.global_position - global_position
        var target_angle = (to_player).angle() - PI / 2
        rotation = lerp_angle(rotation, target_angle, 5 * delta)
        aim(player)
        check_player_collision(to_player)
    if position != enemy_position and !player_entered:
        return_enemy(delta)

func _physics_process(delta: float) -> void:
    if current_state == States.PETROLLING and rotation != enemy_rotation:
        rotation = lerp_angle(rotation, enemy_rotation, 0.1)
    custome_process(delta)

func _on_visiblity_body_entered(body: Node2D) -> void:
    if body == player:
        current_state = States.FIGHTING
        player_entered = true

func _on_visiblity_body_exited(body: Node2D) -> void:
    player_entered = false
    current_state = States.PETROLLING
    

func return_enemy(delta):
    var target: Vector2 = Marker_position-global_position
    var return_angle: float = (target).angle() - PI/2
    print(return_angle)
    rotation = lerp_angle(rotation, return_angle, 5 * delta)
    position = position.move_toward(enemy_position, move_speed * delta)


func check_player_collision(to_player) -> void:
    if ray_cast.get_collider() == player:
        var direction = to_player.normalized()
        velocity = direction * move_speed
        move_and_slide()
    elif ray_cast.get_collider() != player:
        pass

func aim(player) -> void:
    ray_cast.target_position = to_local(player.position)

func take_damage(value):
    health -= value
    if health <= 0:
        print("Enemie Dies")
        queue_free()
