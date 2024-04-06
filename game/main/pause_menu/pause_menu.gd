extends PanelContainer

@export var options_menu: OptionsMenu

var game_overed: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if get_tree().paused:
			unpause()
		else:
			pause()

func pause() -> void:
	if not game_overed:
		get_tree().paused = true
		show()

func unpause() -> void:
	if not game_overed:
		get_tree().paused = false
		hide()


func _on_resume_pressed() -> void:
	unpause()


func _on_menu_pressed() -> void:
	unpause()
	SceneSwitcher.switch_to("res://main_menu/main_menu.tscn")


func _on_options_pressed() -> void:
	options_menu.show()


func _on_restart_pressed() -> void:
	unpause()
	get_tree().reload_current_scene()


func _on_options_menu_confirmed() -> void:
	options_menu.hide()


func _on_pause_pressed() -> void:
	pause()


func _on_main_game_over() -> void:
	game_overed = true
