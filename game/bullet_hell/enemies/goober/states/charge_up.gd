extends GooberEnemyState

@export var charge_timer: Timer

func enter(_msg:={}) -> void:
	enemy.bullet_charge.emitting = true
	charge_timer.start()

func physics_update(delta: float) -> void:
	var player_pos := enemy.player.global_position
	var new_transform := enemy.transform.looking_at(player_pos)
	enemy.transform = enemy.transform.interpolate_with(
		new_transform, 2.5 * delta
	)
	
	enemy.apply_central_force(
		enemy.linear_velocity.rotated(PI) * 3.0
	)

func exit() -> void:
	charge_timer.stop()
	enemy.bullet_charge.emitting = false

func _on_charge_timer_timeout() -> void:
	state_machine.transition_to("Fire")
