extends RigidBody2D

const BULLET = preload("res://goal/hazards/bullet/bullet.tscn")

@export var shape: Polygon2D
@export var collision_shape: CollisionShape2D
@export var owie_collision: CollisionShape2D

@export var explode_particles: GPUParticles2D

var bounces: int = 0

var wind_momma: WindMomma

func _ready() -> void:
	wind_momma = get_tree().get_first_node_in_group("wind_momma")
	wind_momma.wind_updated.connect(update_wind)
	
	angular_velocity = randf_range(-TAU, TAU)
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		shape, "modulate",
		Color(1, 1, 1, 1), 1.5
	).from(Color(1, 0, 0, 0.5))
	tween.tween_property(
		shape, "scale",
		Vector2.ONE, 1.5
	).from(Vector2.ONE * 2.0)
	tween.play()
	
	tween.finished.connect(
		func():
			owie_collision.set_deferred("disabled", false)
	)

func explode() -> void:
	var amount: int = randi_range(5, 10)
	for i: int in range(amount):
		var bullet: RigidBody2D = BULLET.instantiate()
		bullet.global_position = global_position
		var dir := Vector2.from_angle(TAU * randf())
		var speed := randf_range(150, 300)
		bullet.apply_central_impulse(
			dir * speed
		)
		get_tree().current_scene.add_child(bullet)
	
	die()

func die() -> void:
	owie_collision.set_deferred("disabled", true)
	collision_shape.set_deferred("disabled", true)
	constant_force = Vector2.ZERO
	linear_velocity = Vector2.ZERO
	set_deferred("freeze", true)
	
	shape.modulate = Color.GREEN
	explode_particles.restart()
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		shape, "modulate:a",
		0.0, explode_particles.lifetime
	)
	tween.play()

func update_wind(direction: Vector2, speed: float) -> void:
	add_constant_central_force(direction * speed)


func _on_explode_particles_finished() -> void:
	queue_free()


func _on_owie_body_entered(body: Node2D) -> void:
	print("wha")
	body = body as Player
	body.apply_central_impulse(
		global_position.direction_to(body.global_position) * body.linear_velocity.length()
	)
	explode()
