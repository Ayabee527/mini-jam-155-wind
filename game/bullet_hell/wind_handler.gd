class_name BulletHellWindHandler
extends Node2D

signal wind_updated(direction: Vector2, speed: float)

const GUST = preload("res://wind_gust/wind_gust.tscn")

@export var gust_count: int = 30

@export_group("Wind Things")
@export var wind_direction: Vector2 = Vector2.RIGHT:
	set = set_wind_direction
@export var wind_speed: float = 0:
	set = set_wind_speed

var gusts: Array[WindGust] = []

func _ready() -> void:
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

func set_wind_speed(new_speed: float) -> void:
	wind_speed = new_speed
	for gust: WindGust in gusts:
		gust.speed = wind_speed
	
	wind_updated.emit(wind_direction, wind_speed)

func set_wind_direction(new_direction: Vector2) -> void:
	wind_direction = new_direction.normalized()
	for gust: WindGust in gusts:
		gust.direction = wind_direction
	
	wind_updated.emit(wind_direction, wind_speed)
