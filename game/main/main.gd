extends Node2D

@export var wind_momma: WindMomma
@export var player: Player

var tween: Tween
var window_velocity: Vector2 = Vector2.ZERO

var window: Window

func _ready() -> void:
	window = get_window()

func _process(delta: float) -> void:
	window_velocity = window_velocity.move_toward(Vector2.ZERO, 50.0 * delta)
	
	window.position += Vector2i(window_velocity * delta)
	
	contain_window()

func contain_window() -> void:
	var bounce_factor: float = -0.9
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var window_size: Vector2i = window.size
	
	if window.position.x < 0:
		window.position.x = 0
		window_velocity.x *= bounce_factor
	
	if window.position.y < 0:
		window.position.y = 0
		window_velocity.y *= bounce_factor
	
	if window.position.x > screen_size.x - window_size.x:
		window.position.x = screen_size.x - window_size.x
		window_velocity.x *= bounce_factor
	
	if window.position.y > screen_size.y - window_size.y:
		window.position.y = screen_size.y - window_size.y
		window_velocity.y *= bounce_factor

func bump_window(direction: Vector2) -> void:
	window_velocity += direction * 1.0
	
	var speed_multiplier = wind_momma.wind_direction.normalized().dot(
		direction.normalized()
	)
	speed_multiplier = 1 - min(0.1, abs(speed_multiplier))
	if speed_multiplier < 0:
		speed_multiplier *= -1
	
	wind_momma.wind_speed *= 0.75
	wind_momma.wind_direction += ( direction.normalized() * 2.0 )

func _on_player_bumped_wall(direction: Vector2) -> void:
	bump_window(direction)
