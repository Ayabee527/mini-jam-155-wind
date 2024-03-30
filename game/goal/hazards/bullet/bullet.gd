extends RigidBody2D

@export var max_bounces: int = 2

@export var shape: Polygon2D
@export var trail: Trail
@export var collision_shape: CollisionShape2D
@export var owie_collision: CollisionShape2D

@export var explode_particles: GPUParticles2D

@export var bump_sound: AudioStreamPlayer

var bounces: int = 0

var wind_momma: WindMomma

func _ready() -> void:
	wind_momma = get_tree().get_first_node_in_group("wind_momma")
	wind_momma.wind_updated.connect(update_wind)
	
	angular_velocity = randf_range(-TAU, TAU)
	modulate.a = 0.5
	shape.color.g = 1.0
	trail.modulate.g = 1.0

func activate_damage() -> void:
	modulate.a = 1.0
	shape.color.g = 0.0
	trail.modulate.g = 0.0
	owie_collision.set_deferred("disabled", false)

func die() -> void:
	owie_collision.set_deferred("disabled", true)
	constant_force = Vector2.ZERO
	linear_velocity = Vector2.ZERO
	set_deferred("freeze", true)
	
	shape.color.g = 1.0
	trail.modulate.g = 1.0
	shape.color.r = 0.0
	trail.modulate.r = 0.0
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
	tween.play()

func update_wind(direction: Vector2, speed: float) -> void:
	add_constant_central_force(direction * speed)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	bump_sound.play()
	
	if bounces == 0:
		activate_damage()
	
	bounces += 1
	if bounces >= max_bounces:
		collision_shape.set_deferred("disabled", true)


func _on_explode_particles_finished() -> void:
	queue_free()
