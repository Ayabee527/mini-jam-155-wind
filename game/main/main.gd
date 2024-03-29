extends Node2D

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
	var bounce_factor: float = -1.25
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
	window_velocity = direction.rotated(PI) * 1.5

func _on_player_bumped_wall(direction: Vector2) -> void:
	bump_window(direction)
