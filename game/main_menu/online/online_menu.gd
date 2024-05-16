class_name OnlineMenu
extends PanelContainer

const STATS_HOLDER = preload("res://main_menu/stats/stats_holder/stats_holder.tscn")

signal back()

@export var username_input: LineEdit
@export var connect_status: RichTextLabel

@export var endless_holders: VBoxContainer
@export var bullet_holders: VBoxContainer

var refreshing: bool = false

func _ready() -> void:
	await owner.ready
	refresh()

func update_refreshing(new_refreshing: bool) -> void:
	refreshing = new_refreshing

func refresh() -> void:
	if not refreshing:
		refreshing = true
		
		for child in endless_holders.get_children():
			child.queue_free()
		for child in bullet_holders.get_children():
			child.queue_free()
		
		var loader = STATS_HOLDER.instantiate()
		loader.place_label.hide()
		loader.score = "LOADING..."
		loader.modulate = Color.GRAY
		endless_holders.add_child(loader)
		
		var loader_two = STATS_HOLDER.instantiate()
		loader_two.place_label.hide()
		loader_two.score = "LOADING..."
		loader_two.modulate = Color.GRAY
		bullet_holders.add_child(loader_two)
		
		username_input.text = Global.username
		validate_username(Global.username)
		
		load_everything()

func load_everything() -> void:
#region Load Endless Stats
	var endless_result: Dictionary = await SilentWolf.Scores.get_scores(0, "main").sw_get_scores_complete
	print("Endless Scores: " + str(endless_result.scores))
	
	var endless_scores = endless_result.scores
	
	for child in endless_holders.get_children():
		child.queue_free()
	
	for i: int in endless_scores.size():
		
		var score = endless_scores[i]
		
		var holder = STATS_HOLDER.instantiate()
		holder.place = str(i + 1) + ". " + score.player_name
		holder.score = biggen_score(score.score)
		endless_holders.add_child(holder)
#endregion
	
#region Load Bullet Hell Stats
	var bullet_result: Dictionary = await SilentWolf.Scores.get_scores(0, "bullet").sw_get_scores_complete
	print("Bullet Hell Scores: " + str(bullet_result.scores))
	
	var bullet_scores = bullet_result.scores
	
	for child in bullet_holders.get_children():
		child.queue_free()
	
	for i: int in bullet_scores.size():
		
		var score = bullet_scores[i]
		
		var holder = STATS_HOLDER.instantiate()
		holder.place = str(i + 1) + ". " + score.player_name
		holder.score = get_time_text(score.score)
		bullet_holders.add_child(holder)
#endregion
	
	refreshing = false

func update_status(text: String, color: String) -> void:
	connect_status.text = "[u][color=" + color + "]" + text

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

func validate_username(username: String) -> void:
	username = username.to_lower()
	if username == Global.username:
		return
	
	update_status("[wave]processing", "gray")
	print("\n")
	var user_exists = await is_user_real(username)
	print("User Exists?: ", user_exists)
	if user_exists:
		var user_taken = await is_user_taken(username)
		print("User Taken?: ", user_taken)
		if user_taken:
			Global.username = ""
			DataLoader.save_key("username", Global.username)
			update_status("username taken >:(", "red")
			username_input.clear()
		else:
			Global.username = username
			DataLoader.save_key("username", Global.username)
			update_status("logged in :D", "lime")
	else:
		Global.username = username
		DataLoader.save_key("username", Global.username)
		
		await SilentWolf.Scores.save_score(
			Global.username, Global.endless_highs[0][0], "main"
		).sw_save_score_complete
		
		await SilentWolf.Scores.save_score(
			Global.username, Global.bullet_highs[0], "bullet"
		).sw_save_score_complete
		
		update_status("signed in >:D", "lime")
		load_everything()
	
	print("\n")

func _on_username_text_submitted(new_text: String) -> void:
	if not refreshing:
		refreshing = true
		validate_username(new_text)

func is_user_real(username: String) -> bool:
	var exists: bool = false
	
	var endless_results = await SilentWolf.Scores.get_scores_by_player(
		username
	).sw_get_player_scores_complete
	print(username, ", ", endless_results)
	exists = not endless_results.scores.is_empty()
	
	return exists

func is_user_taken(username: String) -> bool:
	var taken: bool = false
	
	print("\n")
	
	var endless_result = await SilentWolf.Scores.get_top_score_by_player(
		username, 10, "main"
	).sw_top_player_score_complete
	print(username, ", Endless Result: ", endless_result)
	var bullet_result = await SilentWolf.Scores.get_top_score_by_player(
		username, 10, "bullet"
	).sw_top_player_score_complete
	print(username, ", Bullet Result: ", bullet_result)
	
	var endless_top = endless_result.top_score.score
	var bullet_top = bullet_result.top_score.score
	
	taken = not (
		(endless_top == Global.endless_highs[0][0])
		and (bullet_top == Global.bullet_highs[0])
	)
	
	return taken

func is_endless_high_valid(username: String) -> bool:
	var endless_result = await SilentWolf.Scores.get_top_score_by_player(
		username, 1, "main"
	).sw_top_player_score_complete
	print(username, ", Endless Result: ", endless_result)
	var endless_top = endless_result.top_score.score
	
	return (endless_top == Global.endless_highs[0][0])

func is_bullet_high_valid(username: String) -> bool:
	var bullet_result = await SilentWolf.Scores.get_top_score_by_player(
		username, 1, "bullet"
	).sw_top_player_score_complete
	print(username, ", Bullet Result: ", bullet_result)
	var bullet_top = bullet_result.top_score.score
	
	return (bullet_top == Global.bullet_highs[0])

func _on_visibility_changed() -> void:
	if visible:
		refresh()