extends PounderEnemyState

@export var dash_speed: float = 250.0
@export var hunt_timer: Timer

func enter(_msg:={}) -> void:
	hunt_timer.start()
	enemy.look_at(enemy.player.global_position)

func physics_update(delta: float) -> void:
	enemy.apply_central_force(
		enemy.linear_velocity.rotated(PI) * 2.0
	)
	
	var player_pos := enemy.player.global_position
	var new_transform := enemy.transform.looking_at(player_pos)
	enemy.transform = enemy.transform.interpolate_with(
		new_transform, 100.0 * delta
	)


func _on_timer_timeout() -> void:
	enemy.apply_central_impulse(
		Vector2.from_angle(enemy.global_rotation) * dash_speed
	)
