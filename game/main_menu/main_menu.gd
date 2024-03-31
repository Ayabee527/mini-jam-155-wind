extends PanelContainer

@export var last_score: Label
@export var high_score: Label
@export var last_time: Label
@export var high_time: Label

func _ready() -> void:
	DataLoader.load_data()
	
	last_score.text = "last "
	if str(Global.latest_score).length() < 6:
		for i: int in range(6 - str(Global.latest_score).length()):
			last_score.text += "0"
	last_score.text += str(Global.latest_score)
	last_time.text = get_time_text(Global.latest_time)
	
	high_score.text = ""
	if str(Global.high_score).length() < 6:
		for i: int in range(6 - str(Global.high_score).length()):
			high_score.text += "0"
	high_score.text += str(Global.high_score)
	high_score.text += " high"
	high_time.text = get_time_text(Global.high_time)
	
	SceneSwitcher.switch_in()

func get_time_text(time_alive: int) -> String:
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

func _on_quit_pressed() -> void:
	DataLoader.save_data()
	get_tree().quit()


func _on_play_pressed() -> void:
	SceneSwitcher.switch_to("res://main/main.tscn")


func _on_tutorial_pressed() -> void:
	pass # Replace with function body.


func _on_options_pressed() -> void:
	SceneSwitcher.switch_to("res://main_menu/options/options_menu.tscn")
