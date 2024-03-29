class_name WindMomma
extends Node2D

const GUST = preload("res://wind_gust/wind_gust.tscn")

@export var gust_count: int = 30

@export_group("Wind Things")
@export var wind_direction: Vector2 = Vector2.RIGHT:
	set = set_wind_direction
@export var wind_speed: float = 0:
	set = set_wind_speed

@export_group("Outer Dependencies")
@export var player: Player
@export var player_goal: PlayerGoal

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
	
	player.constant_force = wind_direction * wind_speed / 5.0
	player_goal.constant_force = wind_direction * wind_speed / 5.0

func set_wind_direction(new_direction: Vector2) -> void:
	wind_direction = new_direction.normalized()
	for gust: WindGust in gusts:
		gust.direction = wind_direction
	
	player.constant_force = wind_direction * wind_speed / 5.0
	player_goal.constant_force = wind_direction * wind_speed / 5.0


func _on_funny_timer_timeout() -> void:
	wind_direction = Vector2.from_angle(TAU * randf())
	wind_speed = randf_range(player.speed * 0.33, player.speed * 0.75) * 5.0
