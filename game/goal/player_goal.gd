class_name PlayerGoal
extends RigidBody2D

signal collected()

@export var stun_timer: Timer
@export var shape: Polygon2D

@export var collect_particles: GPUParticles2D

@export var explod_sound: AudioStreamPlayer
@export var yipee_sound: AudioStreamPlayer

var velocity: Vector2

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	apply_central_force(velocity)

func show_collect() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		shape, "modulate",
		Color(1, 1, 1, 1), 3.0
	).from(Color(0, 1, 0, 0.5))
	tween.tween_property(
		shape, "scale",
		Vector2.ONE, 3.0
	).from(Vector2.ONE * 2.0)
	tween.play()
	
	collect_particles.restart()
	explod_sound.play()
	yipee_sound.play()

func _on_player_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		if stun_timer.is_stopped():
			stun_timer.start()
			show_collect()
			collected.emit()
			
			var dir_to_player := global_position.direction_to(
				body.global_position
			)
			apply_central_impulse(dir_to_player.rotated(PI) * 500.0)
			body.apply_central_impulse(dir_to_player * 750.0)


func _on_move_timer_timeout() -> void:
	var speed: float = randf_range(25, 250)
	var dir: Vector2 = Vector2.from_angle(TAU * randf())
	dir += constant_force.normalized() * 0.5
	dir = dir.normalized()
	
	velocity = dir * speed
