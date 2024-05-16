class_name ScoreHandler
extends Node

signal score_updating()
signal score_updated(new_score: int)

@export var timer_multiplier_curve: Curve

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

func _ready() -> void:
	timer_bar.min_value = 0
	timer_bar.max_value = life_timer.wait_time

func _process(delta: float) -> void:
	timer_bar.value = life_timer.time_left
	
	multiplier += get_timer_multiplier() * delta * 0.75
	multiplier += get_speed_multiplier() * delta * 0.75
	multiplier = lerp(multiplier, 1.0, (multiplier / 50.0) * delta)
	#multiplier = move_toward(multiplier, 1.0, 3.75 * delta)
	
	multiplier = clamp(multiplier, 0.0, 50.0)

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
	multiplier_label.text = "[wave]x" + str(snappedf(multiplier, 0.01))

func _on_player_goal_collected() -> void:
	combo += 1
	if combo > 1:
		score += (100 * (1.0 + (combo * 0.25))) * multiplier
		multiplier *= 3.0


func _on_player_hurt() -> void:
	owies += 1
	multiplier = 0.0
	var score_multiplier = max(0.99 - (owies * 0.001), 0.8)
	print(score_multiplier)
	score *= score_multiplier
