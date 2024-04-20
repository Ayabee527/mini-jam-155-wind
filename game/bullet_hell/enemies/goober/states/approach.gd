extends GooberEnemyState

@export var approach_speed: float = 150.0

var can_charge: bool = false

func enter(_msg:={}) -> void:
	enemy.thruster.emitting = true

func physics_update(delta: float) -> void:
	var player_pos := enemy.player.global_position
	var new_transform := enemy.transform.looking_at(player_pos)
	enemy.transform = enemy.transform.interpolate_with(
		new_transform, 5.0 * delta
	)
	
	var dist_to_player := enemy.global_position.distance_to(
		player_pos
	)
	
	if dist_to_player > 96.0:
		#var dir_to_player := enemy.global_position.direction_to(
			#player_pos
		#)
		enemy.apply_central_force(
			Vector2.from_angle(enemy.global_rotation) * approach_speed
		)
	else:
		if can_charge:
			state_machine.transition_to("ChargeUp")

func exit() -> void:
	enemy.thruster.emitting = false


func _on_enter_notifier_screen_entered() -> void:
	can_charge = true
