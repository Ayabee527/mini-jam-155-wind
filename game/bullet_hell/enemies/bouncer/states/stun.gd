extends FakerEnemyState

const BULLET = preload("res://goal/hazards/bullet/bullet.tscn")

@export var stun_timer: Timer

func enter(_msg:={}) -> void:
	explode()
	stun_timer.start()
	enemy.linear_velocity *= 1.25
	enemy.owie_collision.set_deferred("disabled", true)
	
	enemy.shape.modulate = Color.YELLOW
	enemy.trail.modulate = Color.YELLOW
	enemy.trail.modulate.a = 0.5
	enemy.trail.modulate.a = 0.5

func exit() -> void:
	stun_timer.stop()
	enemy.owie_collision.set_deferred("disabled", false)
	
	enemy.shape.modulate = Color.RED
	enemy.trail.modulate = Color.RED
	enemy.trail.modulate.a = 1.0
	enemy.trail.modulate.a = 1.0

func explode() -> void:
	enemy.explod_sound.play()
	var count: int = 2
	for i: int in range(count):
		var bullet = BULLET.instantiate()
		bullet.global_position = enemy.global_position
		var ang_offset = deg_to_rad(randf_range(-15, 15))
		var dir := enemy.global_position.direction_to(
			enemy.player.global_position
		).rotated(ang_offset)
		var speed := randf_range(100, 200)
		bullet.apply_central_impulse(
			dir * speed
		)
		get_tree().current_scene.add_child(bullet)

func _on_stun_timer_timeout() -> void:
	state_machine.transition_to("Rushdown")
