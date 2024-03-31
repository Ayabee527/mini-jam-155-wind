extends Node2D

signal game_over()

@export var timer_gradient: Gradient

@export var time_timer: Timer
@export var life_timer: Timer
@export var timer_bar: TextureProgressBar
@export var wind_momma: WindMomma
@export var player: Player
@export var player_goal: PlayerGoal

@export var gameover_label: RichTextLabel
@export var multiplier_label: RichTextLabel
@export var timer_label: RichTextLabel

var tween: Tween
var window_velocity: Vector2 = Vector2.ZERO

var window: Window

var time_alive: int = 0

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

func over_game() -> void:
	time_timer.stop()
	player.die()
	player_goal.die()
	
	gameover_label.show()
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		multiplier_label, "modulate:a",
		0.0, 5.0
	)
	tween.play()

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
	over_game()


func _on_player_hurt() -> void:
	if life_timer.time_left - 1 > 0:
		life_timer.start(life_timer.time_left - 1)
	else:
		life_timer.start(0.05)

func get_time_text() -> String:
	var text: String = "00:00"
	
	var minutes: int = 0
	var seconds: int = 0
	
	seconds = time_alive % 60
	minutes = time_alive / 60
	print(time_alive, ", ", minutes, ", ", seconds)
	
	var minute_text: String = "00"
	if minutes < 10:
		minute_text = "0" + str(minutes)
	else:
		minute_text = str(minutes)
	
	var second_text: String = "00"
	if seconds < 10:
		second_text = "0" + str(seconds)
	else:
		second_text = str(seconds)
	
	text = minute_text + ":" + second_text
	
	return text

func _on_timer_timer_timeout() -> void:
	time_alive += 1
	timer_label.text = "[wave]" + get_time_text()
