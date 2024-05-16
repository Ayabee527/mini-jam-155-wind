extends FakerEnemyState

const BULLET = preload("res://goal/hazards/bullet/bullet.tscn")

@export var bullet_count: int = 1
@export var trail: Trail

var entered: bool = false

func enter(_msg:={}) -> void:
	entered = false
	explode()
	#enemy.linear_velocity *= 1.25
	enemy.owie_collision.set_deferred("disabled", true)
	
	trail.hide()
	enemy.shape.modulate = Color.YELLOW
	#enemy.trail.modulate = Color.YELLOW
	#enemy.trail.modulate.a = 0.5
	await get_tree().create_timer(0.5, false).timeout
	entered = true

func exit() -> void:
	trail.show()
	enemy.shape.modulate = Color.RED
	#enemy.trail.modulate = Color.RED
	#enemy.trail.modulate.a = 1.0
	
	await get_tree().process_frame
	enemy.owie_collision.set_deferred("disabled", false)

func explode() -> void:
	enemy.explod_sound.play()
	for i: int in range(bullet_count):
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


func _on_faker_body_entered(body: Node) -> void:
	if is_active and entered:
		state_machine.transition_to("Rushdown")
