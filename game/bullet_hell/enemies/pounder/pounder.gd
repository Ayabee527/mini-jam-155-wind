class_name PounderEnemy
extends RigidBody2D

@export var shape: Polygon2D
@export var trail: Trail
@export var explosion: Explosion
@export var collision_shape: CollisionShape2D
@export var detect_collision: CollisionShape2D
@export var explode_particles: GPUParticles2D

var player: Player

var dead: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func die() -> void:
	if not dead:
		dead = true
		set_deferred("freeze", true)
		detect_collision.set_deferred("disabled", true)
		collision_shape.set_deferred("disabled", true)
		
		explode_particles.restart()
		shape.modulate = Color.GREEN
		trail.modulate = Color.GREEN
		
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

func explode() -> void:
	if not dead:
		explosion.current_radius = explosion.final_radius
		explosion.explode()
		await explosion.tree_exited
		queue_free()

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is Player:
		explode()

func _on_enter_notifier_screen_entered() -> void:
	collision_shape.set_deferred("disabled", false)


func _on_explosion_exploded() -> void:
	set_deferred("freeze", true)
	detect_collision.set_deferred("disabled", true)
	collision_shape.set_deferred("disabled", true)
	shape.hide()
	trail.hide()


func _on_explode_particles_finished() -> void:
	queue_free()
