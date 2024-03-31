extends PanelContainer

@export var data_loader: DataLoader

func _ready() -> void:
	data_loader.load_data()
	data_loader.save_data()
	
	SceneSwitcher.switch_in()

func _on_quit_pressed() -> void:
	data_loader.save_data()
	get_tree().quit()


func _on_play_pressed() -> void:
	SceneSwitcher.switch_to("res://main/main.tscn")


func _on_tutorial_pressed() -> void:
	pass # Replace with function body.


func _on_options_pressed() -> void:
	SceneSwitcher.switch_to("res://main_menu/options/options_menu.tscn")
