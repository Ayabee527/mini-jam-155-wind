extends Node

var ACHIEVEMENTS = {
	"Very Nice!": {
		"completed": false,
		"description": "Hit the goal 69 times in an endless run.",
	},
	
	"Voluntary Celibate!": {
		"completed": false,
		"description": "Don't hit the goal once in an endless run.",
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
	
	"Okay You're Pretty Bad!": {
		"completed": false,
		"description": "Finish an endless run with less than 1k score.",
	},
	
	"They're In The Walls!": {
		"completed": false,
		"description": "Hit the goal 10 times without touching the edges.",
	},
	
	"First Of Many!": {
		"completed": false,
		"description": "End your first endless run.",
	},
	
	"Go-Getter!": {
		"completed": false,
		"description": "Get a new highscore 5 times.",
	},
	
	"Achievement Achiever!": {
		"completed": false,
		"description": "Unlock all achievements.",
	},
}

const SAVE_PATH = "user://achievements.cfg"
const VARAIBLE_SECTION = "TRACKERS"
const ACHIEVEMENT_SECTION = "ACHIEVEMENTS"

# RUN-BOUND VARIABLES
var ball_hits: int = 0:
	set(new_ball_hits):
		ball_hits = new_ball_hits
		if ball_hits == 70:
			complete_very_nice()
var score: int = 0

# PERSISTENT VARIABLES

func save_persistents(config: ConfigFile) -> void:
	pass

func save_achievements() -> void:
	var config = ConfigFile.new()
	
	save_persistents(config)
	
	config.set_value(ACHIEVEMENT_SECTION, "achievements", ACHIEVEMENTS)
	
	config.save(SAVE_PATH)

func load_achievements() -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	if error != OK:
		return

func complete(achievement: String) -> void:
	ACHIEVEMENTS[achievement]["completed"] = true

func uncomplete(achievement: String) -> void:
	ACHIEVEMENTS[achievement]["completed"] = false

func complete_very_nice() -> void:
	complete("Very Nice!")
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
