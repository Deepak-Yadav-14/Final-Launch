extends ShootingEnemy

@export var markers: Array[NodePath] = []
@onready var marker_nodes: Array[Marker2D] = []

var current_target_index: int = -1
var current_target_position: Vector2

func _ready() -> void:
    super()  # Call parent _ready
    for path in markers:
        marker_nodes.append(get_node(path))
    pick_new_marker()

func _physics_process(delta: float) -> void:
    match current_state:
        States.PATROLLING:
            patrol_to_marker(delta)
        States.FIGHTING:
            var target_angle = (player.global_position - global_position).angle() - PI / 2
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
                pick_new_marker()
            velocity = Vector2.ZERO

    move_and_slide()

func patrol_to_marker(delta: float) -> void:
    var to_target = current_target_position - global_position
    var distance = to_target.length()

    if distance > 10.0:
        var target_angle = to_target.angle() - PI / 2
        rotation = lerp_angle(rotation, target_angle, 5 * delta)
        velocity = to_target.normalized() * move_speed
    else:
        velocity = Vector2.ZERO
        pick_new_marker()

func pick_new_marker() -> void:
    var available_indices = []
    for i in marker_nodes.size():
        if i != current_target_index:
            available_indices.append(i)
    if available_indices.size() > 0:
        current_target_index = available_indices[randi() % available_indices.size()]
        current_target_position = marker_nodes[current_target_index].global_position
