extends Node2D

@export var timer_gradient: Gradient

@export var life_timer: Timer
@export var timer_bar: TextureProgressBar
@export var wind_momma: WindMomma
@export var player: Player

var tween: Tween
var window_velocity: Vector2 = Vector2.ZERO

var window: Window

func _ready() -> void:
	window = get_window()

func _process(delta: float) -> void:
	timer_bar.tint_progress = timer_gradient.sample(
		1.0 - (life_timer.time_left / 12.0)
	)
	
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
	window_velocity += direction * 0.5
	
	wind_momma.wind_speed *= direction.dot(wind_momma.wind_direction)
	wind_momma.wind_direction = direction.normalized()
	#wind_momma.wind_direction += ( direction.normalized() * 2.0 )

func _on_player_bumped_wall(direction: Vector2) -> void:
	wind_momma.wind_speed += direction.length()
	#wind_momma.wind_speed *= 1.01
	
	if abs( wind_momma.wind_direction.dot(direction.normalized()) ) > -0.5:
		wind_momma.wind_direction = direction.normalized()
	#bump_window(direction)


func _on_player_goal_collected() -> void:
	life_timer.start(12)
	wind_momma.wind_speed = 0.0
	bump_window(player.linear_velocity * 1.25)
	print("Goal Got!")


func _on_life_timer_timeout() -> void:
	print("GAME OVER!!!")


func _on_player_hurt() -> void:
	if life_timer.time_left - 3 > 0:
		life_timer.start(life_timer.time_left - 3)
	else:
		life_timer.start(0.05)
