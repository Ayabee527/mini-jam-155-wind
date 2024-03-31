class_name DataLoader
extends Node

const SAVE_PATH = "user://data.score"

func save_data() -> void:
	var data := {}
	data.highscore = Global.high_score
	data.hightime = Global.high_time
	data.windowmove = Global.window_movement
	
	data.master_volume = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("Master")
	)
	data.sfx_volume = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("sfx")
	)
	data.music_volume = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("music")
	)
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(data)

func load_data() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		print("Save found!")
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Master"), data.master_volume
		)
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("sfx"), data.sfx_volume
		)
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("music"), data.music_volume
		)
		
		Global.window_movement = data.windowmove
		Global.high_score = data.highscore
		Global.high_time = data.hightime
	else:
		print("Save not found!")
