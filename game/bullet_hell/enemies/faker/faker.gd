class_name FakerEnemy
extends RigidBody2D

@export var shape: Polygon2D
@export var trail: Trail

@export var collision_shape: CollisionShape2D
@export var owie_collision: CollisionShape2D
@export var die_particles: GPUParticles2D

@export var bump_sound: AudioStreamPlayer
@export var explod_sound: AudioStreamPlayer

var wind_momma: WindMomma
var player: Player
var dead: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	wind_momma = get_tree().get_first_node_in_group("wind_momma")
	look_at(player.global_position)

func die() -> void:
	if not dead:
		die_particles.restart()
		shape.modulate = Color.GREEN
		trail.modulate = Color.GREEN
		set_deferred("freeze", true)
		owie_collision.set_deferred("disabled", true)
		collision_shape.set_deferred("disabled", true)
		
		explod_sound.pitch_scale = 0.25
		explod_sound.play()
		
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.set_parallel()
		tween.tween_property(
			shape, "modulate:a",
			0.0, die_particles.lifetime
		)
		tween.tween_property(
			trail, "modulate:a",
			0.0, die_particles.lifetime
		)
		tween.play()
		dead = true
		await tween.finished
		queue_free()

func _on_enter_notifier_screen_entered() -> void:
	collision_shape.set_deferred("disabled", false)

func _on_bumper_body_entered(body: Node2D) -> void:
	bump_sound.play()
	wind_momma.wind_direction = linear_velocity.normalized()
	wind_momma.wind_speed += 20.0
