extends PanelContainer

@export var options_menu: OptionsMenu
@export var music: AudioStreamPlayer

var game_overed: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if not game_overed:
			if get_tree().paused:
				unpause()
			else:
				pause()

func pause() -> void:
	if not game_overed:
		get_tree().paused = true
		show()
		music.volume_db = linear_to_db(1.0)
		music.pitch_scale = 0.5

func unpause() -> void:
	if not game_overed and not options_menu.visible:
		get_tree().paused = false
		hide()
		music.volume_db = linear_to_db(1.0)
		music.pitch_scale = 1.0


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
	print("no more pause")
	game_overed = true
