class_name ScoreHandler
extends Node

signal score_updating()
signal score_updated(new_score: int)

@export var timer_multiplier_curve: Curve
@export var multiplier_gradient: Gradient

@export_group("Outer Dependencies")
@export var player: Player
@export var player_goal: PlayerGoal
@export var life_timer: Timer

@export var multiplier_label: RichTextLabel
@export var score_label: RichTextLabel
@export var timer_bar: TextureProgressBar

var owies: int = 0
var combo: int = 0
var multiplier: float = 1.0:
	set = set_multiplier

var score: int = 0:
	set = set_score
var last_score: int = 0
var latest_plus: int = 0

var game_overed: bool = false

func _ready() -> void:
	timer_bar.min_value = 0
	timer_bar.max_value = life_timer.wait_time

func _process(delta: float) -> void:
	timer_bar.value = life_timer.time_left
	
	if not game_overed:
		multiplier += get_timer_multiplier() * delta * 0.75
		multiplier += get_speed_multiplier() * delta * 0.75
		#multiplier = lerp(multiplier, 1.0, (multiplier / 200.0) * delta)
		if multiplier < 50.0:
			multiplier = move_toward(multiplier, 1.0, 4.0 * delta)
		
		multiplier = clamp(multiplier, 0.0, 50.0)
		if multiplier >= 50.0:
			AchievementHandler.complete("IT'S OVER X50!")

func get_speed_multiplier() -> float:
	var multi: float = 0
	
	multi = max(
		player.linear_velocity.length() / (player.speed * 0.25),
		0
	)
	multi += max(
		player_goal.linear_velocity.length() / 210.0,
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
	score_updating.emit()
	
	var tween = create_tween()
	tween.tween_method(
		increment_score, last_score, score, 1.0
	)
	last_score = score
	
	tween.finished.connect(
		func():
			score_updated.emit(score)
	)

func increment_score(new_score: int):
	score_label.text = "[center][shake rate=10 level=24]"
	score_label.text += str(new_score)

func set_multiplier(new_multiplier: float) -> void:
	multiplier = max(0, new_multiplier)
	var multiplier_percent = multiplier / 50.0
	if multiplier < 50.0:
		multiplier_label.text = "[wave]x" + str(snappedf(multiplier, 0.01))
	else:
		if multiplier_label.text != "[shake]x50":
			multiplier_label.text = "[shake]x50"
	
	var color = multiplier_gradient.sample(multiplier_percent)
	multiplier_label.modulate.r = color.r
	multiplier_label.modulate.g = color.g
	multiplier_label.modulate.b = color.b

func _on_player_goal_collected() -> void:
	combo += 1
	if combo > 1:
		latest_plus = (50 * (1.0 + (combo * 0.25))) * multiplier
		score += latest_plus
		multiplier += 5.0
		print_rich("[shake][color=green]GAINED " + str(latest_plus) + " SCORE!")


func _on_player_hurt() -> void:
	owies += 1
	multiplier -= 5.0
	var score_multiplier = min(0.5 + (owies * 0.025), 2.0)
	print_rich("[shake][color=red]SCORE MULTIPLIER: " + str(score_multiplier))
	score -= ceili(latest_plus * score_multiplier)
	latest_plus *= 0.75
	print_rich("[shake][color=red]LOST " + str(ceili(latest_plus * score_multiplier)) + " SCORE!")


func _on_endless_game_over() -> void:
	game_overed = true
