class_name AchievementBox
extends PanelContainer

@export var achieved: bool = false
@export var achievement_name: String
@export_multiline var achievement_description: String

@export_group("Inner Dependencies")
@export var icon: TextureRect
@export var name_label: Label
@export var desc_label: Label
@export var blocker: ColorRect

func _ready() -> void:
	name_label.text = achievement_name
	desc_label.text = achievement_description
	blocker.visible = not achieved
	icon.modulate.g = float(achieved)
	icon.modulate.b = float(achieved)
