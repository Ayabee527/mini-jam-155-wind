extends PanelContainer

@export var description_label: RichTextLabel


func set_description_text(text: String) -> void:
	description_label.text = "[wave amp=16 freq=25][center]"
	description_label.text += text

func _on_endless_mouse_entered() -> void:
	set_description_text("see how high you can get your highscore!")


func _on_bullet_hell_mouse_entered() -> void:
	set_description_text("see how long you can survive an onslaught!")


func _on_rouge_like_mouse_entered() -> void:
	set_description_text("coming soon!")


func _on_endless_mouse_exited() -> void:
	set_description_text("choose a gamemode!")


func _on_bullet_hell_mouse_exited() -> void:
	set_description_text("choose a gamemode!")


func _on_rouge_like_mouse_exited() -> void:
	set_description_text("choose a gamemode!")


func _on_back_pressed() -> void:
	hide()


func _on_endless_pressed() -> void:
	SceneSwitcher.switch_to("res://endless/endless.tscn")


func _on_bullet_hell_pressed() -> void:
	pass # Replace with function body.


func _on_rouge_like_pressed() -> void:
	print("wait for 1.2 sweetie :3")
