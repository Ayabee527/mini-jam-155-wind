extends RigidBody2D

@export var shape: Node2D
@export var trail: Trail
@export var collision_shape: CollisionShape2D
@export var barrier_collision: CollisionShape2D
@export var barrier_line: Line2D
@export var barrier_preview: Line2D

@export var explode_particles: GPUParticles2D
@export var freeze_timer: Timer

var wind_momma: WindMomma

func _ready() -> void:
	wind_momma = get_tree().get_first_node_in_group("wind_momma")
	wind_momma.wind_updated.connect(update_wind)
	
	add_constant_central_force(wind_momma.wind_direction * wind_momma.wind_speed)
	
	angular_velocity = randf_range(-TAU * 2.0, TAU * 2.0)
	
	freeze_timer.start()

func die() -> void:
	barrier_collision.set_deferred("disabled", true)
	collision_shape.set_deferred("disabled", true)
	
	freeze_timer.stop()
	constant_force = Vector2.ZERO
	linear_velocity = Vector2.ZERO
	set_deferred("freeze", true)
	
	shape.modulate = Color.GREEN
	trail.modulate = Color.GREEN
	barrier_line.modulate = Color.GREEN
	explode_particles.restart()
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		shape, "modulate:a",
		0.0, explode_particles.lifetime
	)
	tween.tween_property(
		trail, "modulate:a",
		0.0, explode_particles.lifetime
	)
	tween.tween_property(
		barrier_line, "width",
		0, 0.33
	)
	tween.play()

func freeze_barrier() -> void:
	constant_force = Vector2.ZERO
	linear_velocity = Vector2.ZERO
	set_deferred("freeze", true)
	
	barrier_collision.set_deferred("disabled", false)
	collision_shape.set_deferred("disabled", true)
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		barrier_line, "width",
		8, 0.33
	).from(0.0)
	tween.play()
	tween.finished.connect(
		func():
			barrier_preview.hide()
	)

func update_wind(direction: Vector2, speed: float) -> void:
	constant_force = Vector2.ZERO
	add_constant_central_force(direction * speed)

func _on_body_entered(body: Node) -> void:
	pass
	#if not freeze_timer.is_stopped():
		#linear_velocity *= 1.25


func _on_explode_particles_finished() -> void:
	queue_free()


func _on_freeze_timer_timeout() -> void:
	freeze_barrier()
