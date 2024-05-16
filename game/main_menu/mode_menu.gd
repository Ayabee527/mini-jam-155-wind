extends PanelContainer

@export var bullet_hell: PanelContainer
@export var bullet_hell_button: Button
@export var bullet_hell_description: Label

func _ready() -> void:
	await owner.ready
	bullet_hell_unlock()

func bullet_hell_unlock() -> void:
	print(Global.endless_highs[0][0])
	if Global.endless_highs[0][0] < 50_000:
		bullet_hell.modulate = Color.GRAY
		bullet_hell_button.disabled = true
		bullet_hell_description.text = "GET 50K+ IN ENDLESS TO UNLOCK!"
	else:
		if Global.bullet_highs[0] == 0:
			bullet_hell.modulate = Color.YELLOW

func _on_back_pressed() -> void:
	hide()


func _on_endless_pressed() -> void:
	SceneSwitcher.switch_to("res://endless/endless.tscn")


func _on_bullet_hell_pressed() -> void:
	SceneSwitcher.switch_to("res://bullet_hell/bullethell.tscn")


func _on_rogue_lite_pressed() -> void:
	print("Wait for 1.2 sweetie :3")
