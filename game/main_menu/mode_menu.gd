extends PanelContainer


func _on_back_pressed() -> void:
	hide()


func _on_endless_pressed() -> void:
	SceneSwitcher.switch_to("res://endless/endless.tscn")


func _on_bullet_hell_pressed() -> void:
	SceneSwitcher.switch_to("res://bullet_hell/bullethell.tscn")


func _on_rogue_lite_pressed() -> void:
	print("Wait for 1.2 sweetie :3")
