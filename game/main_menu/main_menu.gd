extends PanelContainer

@export var quit_butt: Button

@export var options_menu: OptionsMenu
@export var achieves_menu: AchievesMenu
@export var stats_menu: StatsMenu
@export var mode_menu: PanelContainer
@export var online_menu: OnlineMenu

func _ready() -> void:
	DataLoader.load_config()
	await get_tree().process_frame
	AchievementHandler.load_achievements()
	await get_tree().process_frame
	
	if OS.has_feature("web"):
		quit_butt.hide()
	
	SceneSwitcher.switch_in()
	achieves_menu.initialize()

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
	mode_menu.show()


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


func _on_stats_pressed() -> void:
	stats_menu.show()


func _on_stats_menu_back() -> void:
	stats_menu.hide()


func _on_leaderboards_pressed() -> void:
	online_menu.show()


func _on_online_menu_back() -> void:
	online_menu.hide()
