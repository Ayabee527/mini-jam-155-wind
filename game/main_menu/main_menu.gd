extends PanelContainer

@export var quit_butt: Button

@export var last_score: Label
@export var high_score: Label
@export var last_time: Label
@export var high_time: Label

@export var options_menu: OptionsMenu
@export var achieves_menu: AchievesMenu

func _ready() -> void:
	DataLoader.load_config()
	AchievementHandler.load_achievements()
	
	if OS.has_feature("web"):
		quit_butt.hide()
	
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
	if not OS.has_feature("web"):
		DataLoader.save_config()
		get_tree().quit()


func _on_play_pressed() -> void:
	SceneSwitcher.switch_to("res://main/main.tscn")


func _on_tutorial_pressed() -> void:
	SceneSwitcher.switch_to("res://main_menu/tutorial/tutorial.tscn")


func _on_options_pressed() -> void:
	options_menu.show()


func _on_options_menu_confirmed() -> void:
	options_menu.hide()


func _on_achieves_pressed() -> void:
	achieves_menu.show()


func _on_achieves_menu_back() -> void:
	achieves_menu.hide()
