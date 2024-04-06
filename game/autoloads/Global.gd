extends Node

var game_version: String = "1.0.1"
var mouse_control: bool = false
var window_movement: bool = true
var sfx_volume: float
var music_volume: float

var latest_score: int = 0:
	set = set_latest_score
var latest_time: int = 0

var high_score: int = 0
var high_time: int = 0

func set_latest_score(new_score: int) -> void:
	latest_score = new_score
	
	if latest_score > high_score:
		high_score = latest_score
		high_time = latest_time
		DataLoader.save_data()
		return
	
	if latest_score == high_score:
		if latest_time < high_time:
			high_time = latest_time
			DataLoader.save_data()
