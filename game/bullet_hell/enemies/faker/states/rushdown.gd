extends FakerEnemyState

@export var rush_speed: float = 500.0

func physics_update(delta: float) -> void:
	var player_pos := enemy.player.global_position
	var new_transform := enemy.transform.looking_at(player_pos)
	enemy.transform = enemy.transform.interpolate_with(
		new_transform, 20.0 * delta
	)
	
	enemy.apply_central_force(
		Vector2.from_angle(enemy.global_rotation) * rush_speed
	)


func _on_faker_body_entered(body: Node) -> void:
	if is_active:
		state_machine.transition_to("Stun")
