extends CharacterBody2D

@export var player: CharacterBody2D
@export var health: int = 10
@export var move_speed: float = 150.0
@export var detection_range: float = 300.0
@export var attack_range: float = 100.0
@export var enemy:Node2D

@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $Dog_Enemy/AnimationPlayer


var can_attack: bool = false

func _physics_process(delta: float) -> void:
	
	if not is_instance_valid(player):
		return

	var distance = global_position.distance_to(player.global_position)
	
	var direction = velocity.normalized()
	if distance <= detection_range:
		#look_at(player.global_position)
		anim.play("Attack")
		if distance > attack_range:
			can_attack = false
			velocity = (player.global_position - global_position).normalized() * move_speed
		else:
			velocity = Vector2.ZERO
			if not can_attack:
				can_attack = true
				timer.start()
		if direction.x > 0:
			enemy.scale.x = abs(enemy.scale.x)
		else:
			enemy.scale.x = -abs(enemy.scale.x)
			
			
	else:
		velocity = Vector2.ZERO
		can_attack = false
		if timer.is_stopped() == false:
			timer.stop()
	
	
	move_and_slide()

func _on_timer_timeout() -> void:
	if is_instance_valid(player) and global_position.distance_to(player.global_position) <= attack_range:
		player.take_damage(2)  # Assumes player has a take_damage() method

func take_damage(value):
	health -= value
	if health <= 0:
		print("Enemy Dies")
		queue_free()
