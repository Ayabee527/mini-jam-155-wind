extends Node

var ACHIEVEMENTS = {
	"First Of Many!": {
		"completed": false,
		"description": "End your first endless run.",
	},
	
	"Voluntary Celibate!": {
		"completed": false,
		"description": "Don't hit the goal once in an endless run.",
	},
	
	"Okay You're Pretty Bad!": {
		"completed": false,
		"description": "Finish an endless run with less than 1k score.",
	},
	
	"Okay, You're Pretty Good!": {
		"completed": false,
		"description": "Get a 25k+ score endless run.",
	},
	
	"Okay, You're Very Good!": {
		"completed": false,
		"description": "Get a 50k+ score endless run.",
	},
	
	"Okay, You're Too Good!": {
		"completed": false,
		"description": "Get a 75k+ score endless run.",
	},
	
	"Okay, You Can Stop Now!": {
		"completed": false,
		"description": "Get a 100k+ score endless run.",
	},
	
	"Tryhard!": {
		"completed": false,
		"description": "Get a 150k+ score endless run.",
	},
	
	"Maybe You Should Go Outside!": {
		"completed": false,
		"description": "Get a 200k+ score endless run.",
	},
	
	"They're In The Walls!": {
		"completed": false,
		"description": "Hit the goal 5 times without touching the edges.",
	},
	
	"Very Nice!": {
		"completed": false,
		"description": "Hit the goal 69 times in an endless run.",
	},
}

var ACHIEVEMENT_KEYS: Array

signal achievement_complete(name: String, description: String)

const SAVE_PATH = "user://achievements.cfg"
const VARAIBLE_SECTION = "TRACKERS"
const ACHIEVEMENT_SECTION = "ACHIEVEMENTS"
const SAVE_PASSWORD = "SiLLY :3"

# RUN-BOUND VARIABLES
var ball_hits: int = 0:
	set(new_ball_hits):
		ball_hits = new_ball_hits
		if ball_hits == 6:
			if wall_hits == 0:
				complete("They're In The Walls!")
		if ball_hits == 70:
			complete("Very Nice!")
var score: int = 0
var wall_hits: int = 0

func _ready() -> void:
	ACHIEVEMENT_KEYS = ACHIEVEMENTS.keys()

func reset_run_bounds() -> void:
	score = 0
	wall_hits = 0
	ball_hits = 0

func save_achievements() -> void:
	var config = ConfigFile.new()
	
	config.set_value(ACHIEVEMENT_SECTION, "achievements", ACHIEVEMENTS)
	
	config.save_encrypted_pass(SAVE_PATH, SAVE_PASSWORD)

func load_achievements() -> void:
	var config = ConfigFile.new()
	var error = config.load_encrypted_pass(SAVE_PATH, SAVE_PASSWORD)
	
	if error != OK:
		return
	
	ACHIEVEMENTS = config.get_value(ACHIEVEMENT_SECTION, "achievements", ACHIEVEMENTS)
	
	if Global.high_score > 0:
		complete("First Of Many!")
	
	if Global.high_score < 1000:
		complete("Okay You're Pretty Bad!")
	
	if Global.high_score >= 25_000:
		complete("Okay, You're Pretty Good!")
	if Global.high_score >= 50_000:
		complete("Okay, You're Very Good!")
	if Global.high_score >= 75_000:
		complete("Okay, You're Too Good!")
	if Global.high_score >= 100_000:
		complete("Okay, You Can Stop Now!")
	if Global.high_score >= 150_000:
		complete("Tryhard!")
	if Global.high_score >= 200_000:
		complete("Maybe You Should Go Outside!")

func complete(achievement: String) -> void:
	if not ACHIEVEMENTS[achievement]["completed"]:
		achievement_complete.emit(achievement, ACHIEVEMENTS[achievement]["description"])
		ACHIEVEMENTS[achievement]["completed"] = true
		save_achievements()

func uncomplete(achievement: String) -> void:
	ACHIEVEMENTS[achievement]["completed"] = false
	save_achievements()

func check_game_over() -> void:
	if ball_hits == 1:
		complete("Voluntary Celibate!")
	
	if score < 1000:
		complete("Okay You're Pretty Bad!")
	
	if score >= 25_000:
		complete("Okay, You're Pretty Good!")
	if score >= 50_000:
		complete("Okay, You're Very Good!")
	if score >= 75_000:
		complete("Okay, You're Too Good!")
	if score >= 100_000:
		complete("Okay, You Can Stop Now!")
	if score >= 150_000:
		complete("Tryhard!")
	if score >= 200_000:
		complete("Maybe You Should Go Outside!")
	
	if Global.high_score > 0:
		complete("First Of Many!")
