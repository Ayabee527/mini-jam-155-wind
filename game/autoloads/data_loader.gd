extends Node

const CURRENT_GAME_VERSION: String = "1.1.1"

const SAVE_PATH: String = "user://data.cfg"
const USER_NAME: String = "USER"

func check_compatibility(version: String) -> String:
	var upgraded_version: String = "1.0.0"
	
	match version:
		"NO SAVE":
			save_config()
			upgraded_version = CURRENT_GAME_VERSION
		"1.0.0":
			var old_save_path = "user://data.score"
			var save_data: Dictionary = {}
			
			if FileAccess.file_exists(old_save_path):
				var file = FileAccess.open(old_save_path, FileAccess.READ)
				save_data = file.get_var()
			else:
				upgraded_version = "NO SAVE"
				return upgraded_version
			
			var config = ConfigFile.new()
			config.set_value(USER_NAME, "game_version", "1.0.1")
			
			config.set_value(USER_NAME, "master_volume", save_data.master_volume)
			config.set_value(USER_NAME, "sound_volume", save_data.sfx_volume)
			config.set_value(USER_NAME, "music_volume", save_data.music_volume)
			config.set_value(USER_NAME, "window_movement", save_data.windowmove)
			config.set_value(USER_NAME, "high_score", save_data.highscore)
			config.set_value(USER_NAME, "high_time", save_data.hightime)
			
			config.set_value(USER_NAME, "mouse_control", Global.mouse_control)
			config.set_value(USER_NAME, "move_up_keybinds", InputMap.action_get_events("move_up"))
			config.set_value(USER_NAME, "move_left_keybinds", InputMap.action_get_events("move_left"))
			config.set_value(USER_NAME, "move_down_keybinds", InputMap.action_get_events("move_down"))
			config.set_value(USER_NAME, "move_right_keybinds", InputMap.action_get_events("move_right"))
			
			config.save(SAVE_PATH)
			
			upgraded_version = "1.0.1"
		"1.0.1":
			var config = ConfigFile.new()
			config.load(SAVE_PATH)
			
			var highscore = config.get_value(USER_NAME, "high_score")
			var hightime = config.get_value(USER_NAME, "high_time")
			
			var endless_highscores = Global.endless_highs
			endless_highscores[0] = [highscore, hightime]
			config.set_value(USER_NAME, "endless_highscores", endless_highscores)
			
			config.erase_section_key(USER_NAME, "high_score")
			config.erase_section_key(USER_NAME, "high_time")
			
			var bullet_highscores = Global.bullet_highs
			config.set_value(USER_NAME, "bullet_highscores", bullet_highscores)
			
			config.set_value(USER_NAME, "username", Global.username)
			config.set_value(USER_NAME, "latest_endless_score", Global.latest_score)
			config.set_value(USER_NAME, "latest_endless_time", Global.latest_time)
			config.set_value(USER_NAME, "latest_bullet_time", Global.latest_bullet_time)
			
			config.set_value(USER_NAME, "game_version", "1.1")
			
			config.save(SAVE_PATH)
			
			upgraded_version = "1.1"
		"1.1":
			var config = ConfigFile.new()
			config.load(SAVE_PATH)
			
			var username = config.get_value(USER_NAME, "username")
			
			Global.past_username = username
			config.set_value(USER_NAME, "past_username", Global.past_username)
			
			config.save(SAVE_PATH)
			
			AchievementHandler.update_achievements()
			
			upgraded_version = "1.1.1"
		CURRENT_GAME_VERSION:
			upgraded_version = CURRENT_GAME_VERSION
	
	return upgraded_version

func save_config() -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	if error != OK:
		return
	
	config.set_value(USER_NAME, "game_version", CURRENT_GAME_VERSION)
	
	config.set_value(USER_NAME, "master_volume",
			AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("Master")
	))
	config.set_value(USER_NAME, "sound_volume",
			AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("sfx")
	))
	config.set_value(USER_NAME, "music_volume",
			AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("music")
	))
	config.set_value(USER_NAME, "window_movement", Global.window_movement)
	config.set_value(USER_NAME, "endless_highscores", Global.endless_highs)
	config.set_value(USER_NAME, "bullet_highscores", Global.bullet_highs)
	config.set_value(USER_NAME, "username", Global.username)
	config.set_value(USER_NAME, "past_username", Global.past_username)
	
	config.set_value(USER_NAME, "latest_endless_score", Global.latest_score)
	config.set_value(USER_NAME, "latest_endless_time", Global.latest_time)
	config.set_value(USER_NAME, "latest_bullet_time", Global.latest_bullet_time)
	
	config.set_value(USER_NAME, "mouse_control", Global.mouse_control)
	config.set_value(USER_NAME, "move_up_keybinds", InputMap.action_get_events("move_up"))
	config.set_value(USER_NAME, "move_left_keybinds", InputMap.action_get_events("move_left"))
	config.set_value(USER_NAME, "move_down_keybinds", InputMap.action_get_events("move_down"))
	config.set_value(USER_NAME, "move_right_keybinds", InputMap.action_get_events("move_right"))
	
	config.save(SAVE_PATH)

func save_key(key: String, value: Variant) -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	if error != OK:
		return
	
	config.set_value(USER_NAME, key, value)
	
	config.save(SAVE_PATH)

func load_config() -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	var save_version: String = "1.0.0"
	
	if error != OK:
		save_version = "1.0.0"
	else:
		save_version = config.get_value(USER_NAME, "game_version")
	
	while save_version != CURRENT_GAME_VERSION: 
		save_version = await check_compatibility(save_version)
	
	error = config.load(SAVE_PATH)
	if error != OK:
		return
	
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		config.get_value(USER_NAME, "master_volume")
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("sfx"),
		config.get_value(USER_NAME, "sound_volume")
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("music"),
		config.get_value(USER_NAME, "music_volume")
	)
	
	Global.window_movement = config.get_value(USER_NAME, "window_movement")
	Global.mouse_control = config.get_value(USER_NAME, "mouse_control")
	Global.endless_highs = config.get_value(USER_NAME, "endless_highscores")
	Global.bullet_highs = config.get_value(USER_NAME, "bullet_highscores")
	Global.username = config.get_value(USER_NAME, "username")
	Global.past_username = config.get_value(USER_NAME, "past_username")
	
	Global.latest_score = config.get_value(USER_NAME, "latest_endless_score")
	Global.latest_time = config.get_value(USER_NAME, "latest_endless_time")
	Global.latest_bullet_time = config.get_value(USER_NAME, "latest_bullet_time")
	
	var move_up_keybinds = config.get_value(USER_NAME, "move_up_keybinds")
	var move_left_keybinds = config.get_value(USER_NAME, "move_left_keybinds")
	var move_down_keybinds = config.get_value(USER_NAME, "move_down_keybinds")
	var move_right_keybinds = config.get_value(USER_NAME, "move_right_keybinds")
	
	InputMap.action_erase_events("move_up")
	for event: InputEvent in move_up_keybinds:
		InputMap.action_add_event("move_up", event)
	
	InputMap.action_erase_events("move_left")
	for event: InputEvent in move_left_keybinds:
		InputMap.action_add_event("move_left", event)
	
	InputMap.action_erase_events("move_down")
	for event: InputEvent in move_down_keybinds:
		InputMap.action_add_event("move_down", event)
	
	InputMap.action_erase_events("move_right")
	for event: InputEvent in move_right_keybinds:
		InputMap.action_add_event("move_right", event)
