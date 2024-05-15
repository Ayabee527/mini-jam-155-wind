extends Node

const MAX_HIGHSCORES = 5

var username: String = ""

var game_version: String = "1.0.1"
var mouse_control: bool = false
var window_movement: bool = true
var sfx_volume: float
var music_volume: float

var endless_highs: Array = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
var bullet_highs: Array = [0, 0, 0, 0, 0]

var latest_score: int = 0:
	set = set_latest_score
var latest_time: int = 0

var latest_bullet_time: int = 0:
	set = set_latest_bullet_time

func _ready() -> void:
	SilentWolf.configure({
		"api_key": "97LLX6KMs11oHRJNs7waM1Z7kY9mtEDD1EXe6d2j",
		"game_id": "WindOfChange",
		"log_level": 1
	})

func set_latest_score(new_score: int) -> void:
	latest_score = new_score
	endless_highs.append( [latest_score, latest_time] )
	
	handle_endless_highs()
	
	DataLoader.save_config()

func set_latest_bullet_time(new_time: int) -> void:
	latest_bullet_time = new_time
	bullet_highs.append(latest_bullet_time)
	
	handle_bullet_highs()
	
	DataLoader.save_config()

func handle_endless_highs() -> void:
	# [score, time]
	var sort_descend = func(a, b):
		if a[0] > b[0]:
			return true
		elif a[0] == b[0]:
			if a[1] > b[1]:
					return true
		else:
			return false
	
	if endless_highs.size() > MAX_HIGHSCORES:
		endless_highs.sort_custom(sort_descend)
		endless_highs.resize(MAX_HIGHSCORES)
	
	print(endless_highs)
	if not Global.username.is_empty():
		var sw_result: Dictionary = await SilentWolf.Scores.save_score(
			Global.username, endless_highs[0][0]
		).sw_save_score_complete
		print("Score persisted successfully: " + str(sw_result.score_id))

func handle_bullet_highs() -> void:
	# time
	var sort_descend = func(a, b):
		if a > b:
			return true
		else:
			return false
	
	if bullet_highs.size() > MAX_HIGHSCORES:
		bullet_highs.sort_custom(sort_descend)
		bullet_highs.resize(MAX_HIGHSCORES)
	
	print(bullet_highs)
	if not Global.username.is_empty():
		var sw_result: Dictionary = await SilentWolf.Scores.save_score(
			Global.username, bullet_highs[0], "bullet"
		).sw_save_score_complete
		print("Score persisted successfully: " + str(sw_result.score_id))
