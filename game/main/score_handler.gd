extends Node

@export var timer_multiplier_curve: Curve

@export_group("Outer Dependencies")
@export var player: Player
@export var player_goal: PlayerGoal
@export var life_timer: Timer

@export var multiplier_label: RichTextLabel
@export var score_label: RichTextLabel
@export var timer_bar: TextureProgressBar

var combo: int = 0
var multiplier: float = 1.0:
	set = set_multiplier

var score: int = 0:
	set = set_score
var last_score: int = 0

func _ready() -> void:
	timer_bar.min_value = 0
	timer_bar.max_value = life_timer.wait_time

func _process(delta: float) -> void:
	timer_bar.value = life_timer.time_left
	
	multiplier += get_timer_multiplier() * delta * 0.75
	multiplier += get_speed_multiplier() * delta * 0.75
	multiplier = lerp(multiplier, 1.0, 0.75 * delta)

func get_speed_multiplier() -> float:
	var multi: float = 0
	
	multi = max(
		player.linear_velocity.length() / (player.speed * 0.5),
		0
	)
	multi += max(
		player_goal.linear_velocity.length() / 250.0,
		0
	)
	
	return multi

func get_timer_multiplier() -> float:
	var multi: float = 0
	
	var time_ratio = 1.0 - (life_timer.time_left / 12.0)
	multi = 5.0 * timer_multiplier_curve.sample(time_ratio)
	
	return multi

func set_score(new_score: int):
	score = max(0, new_score)
	var tween = create_tween()
	tween.tween_method(
		increment_score, last_score, score, 1.0
	)
	last_score = score

func increment_score(new_score: int):
	score_label.text = "[shake rate=10 level=24]"
	score_label.text += str(new_score)

func set_multiplier(new_multiplier: float) -> void:
	multiplier = max(0, new_multiplier)
	multiplier_label.text = "[wave]x" + str(snappedf(multiplier, 0.01))

func _on_player_goal_collected() -> void:
	combo += 1
	if combo > 1:
		multiplier += 1.0 * (1.0 + (combo * 0.25))
		
		score += (100 * (1.0 + (combo * 0.1))) * multiplier


func _on_player_hurt() -> void:
	multiplier = 0.0
	score -= 75 * combo
