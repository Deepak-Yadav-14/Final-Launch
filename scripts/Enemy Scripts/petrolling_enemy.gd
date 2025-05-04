extends ShootingEnemy

@export_enum ("linear","loop") var petrol_type: String = "loop"
@onready var path_follow: PathFollow2D = get_parent() as PathFollow2D
@onready var progress_value: float = 1.0

var speed: int = 70
var direction = 1
var rotating := false
var rotate_timer := 0.0
var rotation_target := 0.0

func _ready() -> void:
	player_rotation = rotation

func  _physics_process(delta: float) -> void:
	#current_state = States.PETROLLING
	custome_process(delta)
	if current_state == States.PETROLLING:
		Petrolling(delta)
	if current_state == States.FIGHTING and rotation != player_rotation:
		var target_angle = (player.global_position - global_position).angle() - PI / 2
		rotation = lerp_angle(rotation, target_angle, 5 * delta)
	if current_state == States.PETROLLING and rotation != player_rotation:
		rotation = lerp_angle(rotation,player_rotation,0.3)
	if rotating:
		rotation = lerp_angle(rotation, rotation_target, 0.1)
		rotate_timer -= delta
		if rotate_timer <= 0.0:
			rotating = false

func Petrolling(delta: float):
	if petrol_type == 'loop':
		progress_value += speed * delta
		path_follow.progress = progress_value
	else:
		if direction == 1:
			if path_follow.progress_ratio >= 1.0:
				await get_tree().create_timer(0.3).timeout
				rotation = lerp_angle(rotation, player_rotation+ PI / 2, 0.2)
				await get_tree().create_timer(1).timeout
				direction = 0
			else:
				progress_value += speed * delta
				path_follow.progress = progress_value
		else:
			if path_follow.progress_ratio <= 0.0:
				await get_tree().create_timer(0.3).timeout
				rotation = lerp_angle(rotation, player_rotation, 0.2)
				await get_tree().create_timer(1).timeout
				direction = 1
			else:
				progress_value -= speed * delta
				path_follow.progress = progress_value
