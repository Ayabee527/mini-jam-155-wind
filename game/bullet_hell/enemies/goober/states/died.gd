extends GooberEnemyState

func enter(_msg:={}) -> void:
	enemy.linear_velocity = Vector2.ZERO
	enemy.angular_velocity = 0.0
	enemy.apply_central_impulse(
		Vector2.from_angle(enemy.global_rotation) * 300.0
	)
	await enemy.die_particles.finished
	enemy.queue_free()
