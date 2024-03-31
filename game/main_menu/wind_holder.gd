extends Node2D

const GUST = preload("res://wind_gust/wind_gust.tscn")

@export var gust_count: int = 30

var wind_direction: Vector2 = Vector2.ZERO
var wind_speed: float = 0.0

var gusts: Array[WindGust]

func _ready() -> void:
	wind_direction = Vector2.from_angle(TAU * randf())
	wind_speed = randf_range(250, 750)
	spawn_winds()

func spawn_winds() -> void:
	var game_size: Vector2 = Vector2(256, 256)
	var center: Vector2 = game_size / 2.0
	
	for i: int in range(gust_count):
		var gust = GUST.instantiate()
		gust.global_position = Vector2(
			center.x + randf_range(-game_size.x * 2.0, game_size.x * 2.0),
			center.y + randf_range(-game_size.x * 2.0, game_size.x * 2.0)
		)
		gust.direction = wind_direction
		gust.speed = wind_speed
		add_child(gust, true)
	
		gusts.append(gust)

func _on_wind_timer_timeout() -> void:
	wind_direction = Vector2.from_angle(TAU * randf())
	wind_speed = randf_range(250, 750)
	
	for gust: WindGust in gusts:
		gust.direction = wind_direction
		gust.speed = wind_speed
