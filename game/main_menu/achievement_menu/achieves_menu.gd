class_name AchievesMenu
extends PanelContainer

const ACHIEVES_BOX = preload("res://main_menu/achievement_menu/achievement_slot/achieve_box.tscn")

signal back()

@export var back_butt: Button

@export var endless_achieves_holder: VBoxContainer
@export var bullet_achieves_holder: VBoxContainer

func _ready() -> void:
	await owner.ready
	initialize()

func initialize():
	AchievementHandler.load_achievements()
	spawn_achieves()
	spawn_bullets()

func _on_back_pressed() -> void:
	AchievementHandler.save_achievements()
	emit_signal("back")

func spawn_achieves() -> void:
	for child in endless_achieves_holder.get_children():
		child.queue_free()
	
	var completed: Array[String] = []
	var uncompleted: Array[String] = []
	
	var keys: Array = AchievementHandler.ENDLESS_ACHIEVEMENTS
	
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
		endless_achieves_holder.add_child(achieves_box)
	
	for achievement: String in uncompleted:
		var achieves_box = ACHIEVES_BOX.instantiate()
		achieves_box.name = achievement
		achieves_box.achievement_name = achievement
		achieves_box.achievement_description = AchievementHandler.ACHIEVEMENTS[achievement]["description"]
		achieves_box.achieved = false
		endless_achieves_holder.add_child(achieves_box)

func spawn_bullets() -> void:
	for child in bullet_achieves_holder.get_children():
		child.queue_free()
	
	var completed: Array[String] = []
	var uncompleted: Array[String] = []
	
	var keys: Array = AchievementHandler.BULLETHELL_ACHIEVEMENTS
	
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
		bullet_achieves_holder.add_child(achieves_box)
	
	for achievement: String in uncompleted:
		var achieves_box = ACHIEVES_BOX.instantiate()
		achieves_box.name = achievement
		achieves_box.achievement_name = achievement
		achieves_box.achievement_description = AchievementHandler.ACHIEVEMENTS[achievement]["description"]
		achieves_box.achieved = false
		bullet_achieves_holder.add_child(achieves_box)

func _on_visibility_changed() -> void:
	if visible:
		initialize()
