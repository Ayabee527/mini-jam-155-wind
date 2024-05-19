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

var latest_score: int = 0
var latest_time: int = 0

var latest_bullet_time: int = 0

func _ready() -> void:
	SilentWolf.configure({
		"api_key": "97LLX6KMs11oHRJNs7waM1Z7kY9mtEDD1EXe6d2j",
		"game_id": "WindOfChange",
		"log_level": 0
	})

func set_latest_score(new_score: int) -> void:
	latest_score = new_score
	endless_highs.append( [latest_score, latest_time] )
	
	handle_endless_highs()
	
	if not username.is_empty():
		SilentWolf.Scores.save_score(
			username, latest_score, "daily_endless"
		)
	
	DataLoader.save_key("endless_highscores", endless_highs)
	DataLoader.save_key("latest_endless_score", latest_score)
	DataLoader.save_key("latest_endless_time", latest_time)
	print_rich("[wave][color=hotpink]SAVED ENDLESS SCORES!")

func set_latest_bullet_time(new_time: int) -> void:
	latest_bullet_time = new_time
	bullet_highs.append(latest_bullet_time)
	
	handle_bullet_highs()
	
	if not username.is_empty():
		SilentWolf.Scores.save_score(
			username, latest_bullet_time, "daily_bullet"
		)
	
	DataLoader.save_key("bullet_highscores", bullet_highs)
	DataLoader.save_key("latest_bullet_time", latest_bullet_time)
	print_rich("[wave][color=hotpink]SAVED BULLET SCORES!")

func handle_endless_highs() -> void:
	# [score, time]
	print_rich("[shake][color=cyan]Old Endless Highs: ", endless_highs)
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
		while endless_highs.size() > MAX_HIGHSCORES:
			endless_highs.pop_back()
	
	print_rich("[shake][color=cyan]New Endless Highs: ", endless_highs)
	if not username.is_empty():
		SilentWolf.Scores.save_score(
			username, endless_highs[0][0], "main"
		)

func handle_bullet_highs() -> void:
	# time
	print_rich("[shake][color=orange]Old Bullet Highs: ", bullet_highs)
	var sort_descend = func(a, b):
		if a > b:
			return true
		else:
			return false
	
	if bullet_highs.size() > MAX_HIGHSCORES:
		bullet_highs.sort_custom(sort_descend)
		while bullet_highs.size() > MAX_HIGHSCORES:
			bullet_highs.pop_back()
	
	print_rich("[shake][color=orange]New Bullet Highs: ", bullet_highs)
	if not username.is_empty():
		SilentWolf.Scores.save_score(
			username, bullet_highs[0], "bullet"
		)
