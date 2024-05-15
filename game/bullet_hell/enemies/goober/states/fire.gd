extends GooberEnemyState

const BULLET = preload("res://goal/hazards/bullet/bullet.tscn")

@export var fire_speed: float = 300.0

@export var stun_timer: Timer
@export var fire_sound: AudioStreamPlayer
@export var dunkin_collision: CollisionShape2D

func enter(_msg:={}) -> void:
	fire()

func fire() -> void:
	#var bullet = BULLET.instantiate()
	#bullet.global_position = enemy.bullet_spawner.global_position
	#bullet.apply_central_impulse(
		#Vector2.from_angle(enemy.global_rotation) * fire_speed
	#)
	#bullet.max_bounces = 2
	#get_tree().current_scene.add_child(bullet)
	
	var side_angle: float = deg_to_rad(15.0)
	var sides: int = 2
	for i: int in range(sides):
		var offset_ang = -side_angle + (2.0 * side_angle * i)
		var side_bullet = BULLET.instantiate()
		side_bullet.global_position = enemy.bullet_spawner.global_position
		side_bullet.apply_central_impulse(
			Vector2.from_angle(enemy.global_rotation + offset_ang) * fire_speed
		)
		side_bullet.max_bounces = 2
		get_tree().current_scene.add_child(side_bullet)
	fire_sound.play()
	
	enemy.apply_central_impulse(
		Vector2.from_angle(enemy.global_rotation).rotated(PI) * fire_speed
	)
	enemy.angular_velocity = 0.0
	stun_timer.start()

func exit() -> void:
	stun_timer.stop()
	
	dunkin_collision.set_deferred("disabled", true)
	enemy.dunked = false

func _on_goober_body_exited(body: Node) -> void:
	if is_active:
		enemy.angular_velocity = 0.0
		enemy.look_at(
			enemy.global_position + enemy.linear_velocity.normalized().rotated(PI)
		)
		
		if body is Player:
			enemy.dunked = true
			dunkin_collision.set_deferred("disabled", false)
			stun_timer.start()
			print("buh")


func _on_stun_timer_timeout() -> void:
	state_machine.transition_to("Approach")
