extends Node2D

@export var collect_panel: Panel
@export var death_bar: TextureProgressBar
@export var timer_label: RichTextLabel

@export var wind_momma: WindMomma

var death_value: float = 0.0

var time_alive: int = 0

var window_velocity: Vector2 = Vector2.ZERO
var used_screen: int = -1
var window: Window

var goal_ready: bool = false

func _ready() -> void:
	window = get_window()
	used_screen = DisplayServer.window_get_current_screen(window.get_window_id())

func _process(delta: float) -> void:
	if not goal_ready:
		death_value -= delta * 2.5
	else:
		death_value += delta
	
	death_value = clamp(death_value, 0.0, 100.0)
	
	death_bar.value = death_value
	
	if Global.window_movement:
		window_velocity = window_velocity.move_toward(Vector2.ZERO, 50.0 * delta)
		
		window.position += Vector2i(window_velocity * delta)
	
	contain_window()

func bump_window(direction: Vector2) -> void:
	if Global.window_movement:
		window_velocity += direction * 0.5
	
	wind_momma.wind_speed *= direction.dot(wind_momma.wind_direction)
	wind_momma.wind_direction = direction.normalized()
	#wind_momma.wind_direction += ( direction.normalized() * 2.0 )

func contain_window() -> void:
	var bounce_factor: float = -0.9
	var screen_origin: Vector2i = DisplayServer.screen_get_usable_rect(used_screen).position
	var screen_size: Vector2i = DisplayServer.screen_get_usable_rect(used_screen).size
	var window_size: Vector2i = window.size
	
	if window.position.x < screen_origin.x:
		window.position.x = screen_origin.x
		window_velocity.x *= bounce_factor
	
	if window.position.y < screen_origin.y:
		window.position.y = screen_origin.y
		window_velocity.y *= bounce_factor
	
	if window.position.x > screen_origin.x + (screen_size.x - window_size.x):
		window.position.x = screen_origin.x + (screen_size.x - window_size.x)
		window_velocity.x *= bounce_factor
	
	if window.position.y > screen_origin.y + (screen_size.y - window_size.y):
		window.position.y = screen_origin.y + (screen_size.y - window_size.y)
		window_velocity.y *= bounce_factor

func collect_goal() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		collect_panel, "modulate:a", 0.0, 1.0
	).from(1.0)

func get_time_text() -> String:
	var text: String = "00:00"
	
	var minutes: int = 0
	var seconds: int = 0
	
	seconds = time_alive % 60
	minutes = time_alive / 60
	
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

func _on_survive_timer_timeout() -> void:
	time_alive += 1
	timer_label.text = "[center][shake rate=10 level=8][wave]" + get_time_text()


func _on_bullet_hell_goal_collected() -> void:
	death_value -= 30
	collect_goal()
	
	wind_momma.wind_direction = Vector2.ZERO
	wind_momma.wind_speed = 0.0
	
	goal_ready = false


func _on_player_hurt() -> void:
	death_value += 20
	


func _on_bullet_hell_goal_activated() -> void:
	goal_ready = true
