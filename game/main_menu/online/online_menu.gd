class_name OnlineMenu
extends PanelContainer

const STATS_HOLDER = preload("res://main_menu/stats/stats_holder/stats_holder.tscn")

signal back()

@export var username_input: LineEdit
@export var connect_status: RichTextLabel

@export var endless_holders: VBoxContainer
@export var bullet_holders: VBoxContainer

var retreiving: bool = false

func _ready() -> void:
	await owner.ready
	initialize()

func initialize() -> void:
	username_input.text = Global.username
	load_endless()
	load_bullet()
	update_status()

func load_endless() -> void:
	var endless_result: Dictionary = await SilentWolf.Scores.get_scores(0, "main").sw_get_scores_complete
	print("Scores: " + str(endless_result.scores))
	
	var scores = endless_result.scores
	
	for i: int in scores.size():
		for child in endless_holders.get_children():
			child.queue_free()
		
		var score = scores[i]
		
		var holder = STATS_HOLDER.instantiate()
		holder.place = str(i + 1) + ". " + score.player_name
		holder.score = biggen_score(score.score)
		endless_holders.add_child(holder)

func load_bullet() -> void:
	var bullet_result: Dictionary = await SilentWolf.Scores.get_scores(0, "bullet").sw_get_scores_complete
	print("Bullet Hell Scores: " + str(bullet_result.scores))
	
	var scores = bullet_result.scores
	
	for i: int in scores.size():
		for child in bullet_holders.get_children():
			child.queue_free()
		
		var score = scores[i]
		
		var holder = STATS_HOLDER.instantiate()
		holder.place = str(i + 1) + ". " + score.player_name
		holder.score = get_time_text(score.score)
		bullet_holders.add_child(holder)

func update_status() -> void:
	if Global.username.is_empty():
		connect_status.text = "[u][color=lightgray]no name :("
	else:
		connect_status.text = "[u][color=lime]connected :D"

func biggen_score(score: int) -> String:
	var total_digits = 6
	var missing_digits = total_digits - str(score).length()
	
	if missing_digits < 1:
		return str(score)
	
	var biggened_score := ""
	for digit in missing_digits:
		biggened_score += "0"
	biggened_score += str(score)
	
	return biggened_score

func get_time_text(time: int) -> String:
	var text: String = "00:00"
	
	var minutes: int = 0
	var seconds: int = 0
	
	seconds = time % 60
	minutes = time / 60
	
	var minute_text: String = "00"
	if minutes < 10:
		minute_text = "0" + str(minutes)
	else:
		minute_text = str(minutes)
	
	var second_text: String = "00"
	if seconds < 10:
		second_text = "0" + str(seconds)
	else:
		second_text = str(seconds)
	
	text = minute_text + ":" + second_text
	
	return text

func _on_back_pressed() -> void:
	back.emit()


func _on_username_text_submitted(new_text: String) -> void:
	Global.username = new_text
	DataLoader.save_key("username", Global.username)
	update_status()


func _on_visibility_changed() -> void:
	if visible:
		initialize()
