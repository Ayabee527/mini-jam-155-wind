extends PanelContainer


func _on_back_pressed() -> void:
	SceneSwitcher.switch_to("res://main_menu/main_menu.tscn")
