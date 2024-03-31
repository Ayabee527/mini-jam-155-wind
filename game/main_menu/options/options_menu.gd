extends PanelContainer

@export var window_move_butt: CheckButton
@export var sound: AudioStreamPlayer

func _ready() -> void:
	window_move_butt.button_pressed = Global.window_movement

func _on_back_pressed() -> void:
	DataLoader.save_data()
	SceneSwitcher.switch_to("res://main_menu/main_menu.tscn")

func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.window_movement = toggled_on


func _on_volume_slider_confirm_volume() -> void:
	sound.play()
