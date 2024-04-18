extends Node2D

@export var timer_label: RichTextLabel

var death_value: float = 0.0

var time_alive: int = 0

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
