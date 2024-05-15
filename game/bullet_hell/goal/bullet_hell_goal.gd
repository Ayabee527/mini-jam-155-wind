class_name BulletHellGoal
extends RigidBody2D

signal collected()
signal activated()

@export var stun_time: float = 10.0

@export_group("Inner Dependencies")
@export var shape: Polygon2D
@export var ring: GPUParticles2D
@export var collision: CollisionShape2D
@export var player_zone_collision: CollisionShape2D

@export var collect_sound: AudioStreamPlayer
@export var ready_sound: AudioStreamPlayer

var wind_momma: WindMomma
var player: Player

var active: bool = true
var dead: bool = false

var magnetize: float = 0.0

func _ready() -> void:
	wind_momma = get_tree().get_first_node_in_group("wind_momma")
	wind_momma.wind_updated.connect(update_wind)
	
	player = get_tree().get_first_node_in_group("player")
	
	add_constant_central_force(wind_momma.wind_direction * wind_momma.wind_speed)

func _physics_process(delta: float) -> void:
	if active:
		magnetize += delta
	
	magnetize_to_player(delta)

func update_wind(direction: Vector2, speed: float) -> void:
	constant_force = Vector2.ZERO
	add_constant_central_force(direction * speed)

func magnetize_to_player(delta: float) -> void:
	var dir = global_position.direction_to(player.global_position)
	constant_force = lerp(
		constant_force, constant_force + (dir * 500.0 * delta), delta * magnetize
	)

func collect() -> void:
	if dead:
		return
	
	active = false
	magnetize = 0.0
	player_zone_collision.set_deferred("disabled", true)
	ring.emitting = false
	shape.color = Color.WHITE
	modulate.a = 0.0
	
	collect_sound.play()
	collected.emit()
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	#tween.tween_property(
		#shape, "color", Color.GREEN, stun_time
	#)
	tween.tween_property(
		self, "modulate:a", 0.25, stun_time
	)
	await tween.finished
	if dead:
		return
	ready_sound.play()
	modulate.a = 1.0
	shape.color = Color.GREEN
	ring.emitting = true
	player_zone_collision.set_deferred("disabled", false)
	activated.emit()
	active = true

func die() -> void:
	collision.set_deferred("disabled", true)
	player_zone_collision.set_deferred("disabled", true)
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		shape, "modulate",
		Color(1, 1, 1, 0), 5.0
	)


func _on_player_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		collect()
		apply_central_impulse(
			Vector2.from_angle(TAU * randf()) * randf_range(250, 750)
		)


func _on_player_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("dunkers"):
		collect()
		apply_central_impulse(
			Vector2.from_angle(TAU * randf()) * randf_range(250, 750)
		)
