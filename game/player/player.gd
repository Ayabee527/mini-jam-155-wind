class_name Player
extends RigidBody2D

signal hurt()
signal bumped_wall(direction: Vector2)

@export var friction: float = 2.0
@export var speed: float = 1000.0

@export_group("Inner Dependencies")
@export var bump_sound: AudioStreamPlayer
@export var ouch_sound: AudioStreamPlayer

@export var shape: Polygon2D
@export var collision: CollisionShape2D
@export var bumper_collision: CollisionShape2D
@export var owie_collision: CollisionShape2D
@export var die_particles: GPUParticles2D
@export var explode_sound: AudioStreamPlayer

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var move_dir: Vector2 = get_move_dir()
	if move_dir.length() > 0:
		apply_central_force(
			get_move_dir() * speed
		)
	else:
		apply_central_force(
			linear_velocity.rotated(PI) * friction
		)

func get_move_dir() -> Vector2:
	if Global.mouse_control:
		if global_position.distance_to(get_global_mouse_position()) < 32.0:
			return Vector2.ZERO
		else:
			return global_position.direction_to(get_global_mouse_position())
	else:
		return Input.get_vector(
			"move_left", "move_right",
			"move_up", "move_down"
		)

func die() -> void:
	collision.set_deferred("disabled", true)
	owie_collision.set_deferred("disabled", true)
	bumper_collision.set_deferred("disabled", true)
	
	set_deferred("freeze", true)
	
	shape.hide()
	die_particles.restart()
	explode_sound.play()

func _on_bumper_body_entered(body: Node2D) -> void:
	emit_signal("bumped_wall", linear_velocity)


func _on_body_entered(body: Node) -> void:
	bump_sound.play()


func _on_owie_detector_area_entered(area: Area2D) -> void:
	print("OWIE!")
	hurt.emit()
	ouch_sound.play()
	apply_central_impulse(
		area.global_position.direction_to(global_position) * speed * 0.5
	)
