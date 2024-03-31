extends PanelContainer

func _ready() -> void:
	SceneSwitcher.switch_in()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	SceneSwitcher.switch_to("res://main/main.tscn")


func _on_tutorial_pressed() -> void:
	pass # Replace with function body.
