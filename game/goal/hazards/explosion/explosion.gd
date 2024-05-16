class_name Explosion
extends Area2D

signal primed()
signal exploded()

@export var color: Color = Color.RED:
	set = set_color
@export var prime_on_ready: bool = true
@export var explode_on_full: bool = true
@export var corners: int = -1
@export var starting_radius: float = 0.0
@export var final_radius: float = 32.0
@export var time_to_full: float = 5.0
@export var linger_time: float = 0.5
@export var harmless: bool = false

@export_group("Inner Dependencies")
@export var final_preview: Polygon2D
@export var current_preview: Polygon2D
@export var explosion_circle: Polygon2D
@export var collision_shape: CollisionShape2D
@export var explode_sound: AudioStreamPlayer

var current_radius: float = 0.0

var prime_tween: Tween

var rotation_speed: float = 0.0

var ploded: bool = false

func _ready() -> void:
	if corners < 3:
		corners = randi_range(3, 16)
	rotation_speed = randf_range(-720.0, 720.0)
	draw_final_preview()
	if prime_on_ready:
		prime()

func _physics_process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta

func prime() -> void:
	# Did you know? Twitch Prime is an absolutely free way to sub if you have Amazon Prime!
	prime_tween = create_tween()
	prime_tween.tween_method(
		update_radius, starting_radius, final_radius, time_to_full
	)
	prime_tween.play()
	await prime_tween.finished
	primed.emit()
	if explode_on_full:
		explode()

func die() -> void:
	harmless = true
	explode()
	
	#var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	#tween.set_parallel()
	#tween.tween_property(
		#self, "modulate:a", 0.0, 0.5
	#)
	#tween.tween_property(
		#self, "scale", Vector2.ZERO, 0.5
	#)
	#await tween.finished
	#queue_free()

func update_radius(new_radius: float) -> void:
	current_radius = new_radius
	draw_current_preview()

func explode() -> void:
	prime_tween.stop()
	if harmless:
		color = Color.GREEN
		collision_shape.set_deferred("disabled", true)
	
	if not ploded:
		ploded = true
		final_preview.hide()
		current_preview.hide()
		draw_explosion_circle()
		
		exploded.emit()
		
		var shape = CircleShape2D.new()
		shape.radius = current_radius
		collision_shape.shape = shape
		explode_sound.play()
		
		await get_tree().create_timer(linger_time).timeout
		collision_shape.set_deferred("disabled", true)
		
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.set_parallel()
		tween.tween_property(
			self, "modulate:a", 0.0, 0.5
		)
		tween.tween_property(
			self, "scale", Vector2.ZERO, 0.5
		)
		await tween.finished
		queue_free()

func draw_final_preview() -> void:
	final_preview.polygon.clear()
	var points: PackedVector2Array = PackedVector2Array()
	for i: int in range(corners):
		var ang = TAU * (float(i) / corners)
		var point = Vector2.from_angle(ang) * final_radius
		points.append(point)
	final_preview.polygon = points

func draw_current_preview() -> void:
	current_preview.polygon.clear()
	var points: PackedVector2Array = PackedVector2Array()
	for i: int in range(corners):
		var ang = TAU * (float(i) / corners)
		var point = Vector2.from_angle(ang) * current_radius
		points.append(point)
	current_preview.polygon = points

func draw_explosion_circle() -> void:
	explosion_circle.polygon.clear()
	var points: PackedVector2Array = PackedVector2Array()
	for i: int in range(corners):
		var ang = TAU * (float(i) / corners)
		var point = Vector2.from_angle(ang) * current_radius
		points.append(point)
	explosion_circle.polygon = points

func set_color(new_color: Color) -> void:
	color = new_color
	
	final_preview.color = color
	current_preview.color = color
	explosion_circle.color = color


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collision_shape.set_deferred("disabled", true)
