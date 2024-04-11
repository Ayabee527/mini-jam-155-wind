class_name AchievesMenu
extends PanelContainer

const ACHIEVES_BOX = preload("res://main_menu/achievement_menu/achievement_slot/achieve_box.tscn")

signal back()

@export var back_butt: Button

@export var achieves_holder: VBoxContainer

func _ready() -> void:
	initialize()

func initialize():
	AchievementHandler.load_achievements()
	spawn_achieves()

func _on_back_pressed() -> void:
	AchievementHandler.save_achievements()
	emit_signal("back")

func spawn_achieves() -> void:
	for child in achieves_holder.get_children():
		child.queue_free()
	
	var completed: Array[String] = []
	var uncompleted: Array[String] = []
	
	var keys: Array = AchievementHandler.ACHIEVEMENT_KEYS
	
	for achievement: String in keys:
		if AchievementHandler.ACHIEVEMENTS[achievement]["completed"]:
			completed.append(achievement)
		else:
			uncompleted.append(achievement)
	
	for achievement: String in completed:
		var achieves_box = ACHIEVES_BOX.instantiate()
		achieves_box.name = achievement
		achieves_box.achievement_name = achievement
		achieves_box.achievement_description = AchievementHandler.ACHIEVEMENTS[achievement]["description"]
		achieves_box.achieved = true
		achieves_holder.add_child(achieves_box)
	
	for achievement: String in uncompleted:
		var achieves_box = ACHIEVES_BOX.instantiate()
		achieves_box.name = achievement
		achieves_box.achievement_name = achievement
		achieves_box.achievement_description = AchievementHandler.ACHIEVEMENTS[achievement]["description"]
		achieves_box.achieved = false
		achieves_holder.add_child(achieves_box)


func _on_visibility_changed() -> void:
	if visible:
		initialize()
