extends ShootingEnemy

@export var markers: Array[NodePath] = []
@onready var marker_nodes: Array[Marker2D] = []
@onready var animation_player: AnimationPlayer = $Torso/AnimationPlayer


var current_target_index: int = -1
var current_target_position: Vector2

func _ready() -> void:
	super()  # Call parent _ready
	for path in markers:
		marker_nodes.append(get_node(path))
	pick_new_marker()

func _physics_process(delta: float) -> void:
	if player_in_range:
		ray_cast.target_position = gun.to_local(player.global_position)
		ray_cast.force_raycast_update()
		if ray_cast.is_colliding():
			#print(ray_cast.get_collider())
			var collider = ray_cast.get_collider()
			if collider.is_in_group("Hurt_Detector"):
				var target = collider.get_parent()
				if target == player and current_state != States.FIGHTING:
					current_state = States.FIGHTING
					
	
	if cos(gun.rotation) < 0:
		torso.scale.x = -abs(torso.scale.x)  # Facing left
	else:
		torso.scale.x = abs(torso.scale.x)   # Facing right		
					
	
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
				pick_new_marker()
			velocity = Vector2.ZERO
		States.PATROLLING:
			patrol_to_marker(delta)

	move_and_slide()
	if velocity.length() > 1:
		animation_player.play("enemy_run")
	else:
		animation_player.play("enemy_idle")

func patrol_to_marker(delta: float) -> void:
	var to_target = current_target_position - global_position
	var distance = to_target.length()

	if distance > 10.0:
		velocity = to_target.normalized() * move_speed

		if not player_in_range:
			var move_direction = to_target.angle()
			gun.rotation = lerp_angle(gun.rotation, move_direction, 5 * delta)

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
