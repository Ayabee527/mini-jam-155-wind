extends Node

var ACHIEVEMENTS = {
	# ENDLESS
	
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
		"description": "Game over with 69 in your score.",
	},
	
	# BULLET HELL
	
	"Straight Up Ballin!": {
		"completed": false,
		"description": "Dunk an enemy into the goal."
	},
	
	"Flashing Before My Eyes!": {
		"completed": false,
		"description": "Nearly (but not quite) die from a hit."
	},
	
	"That One Hurt!": {
		"completed": false,
		"description": "End your first bullet-hell run."
	},
	
	"Bullets, No Brains!": {
		"completed": false,
		"description": "Last more than 1 minute in a bullet-hell run."
	},
	
	"Slippery Fella!": {
		"completed": false,
		"description": "Last more than 2 minutes in a bullet-hell run."
	},
	
	"Untouchable!": {
		"completed": false,
		"description": "Last more than 3 minutes in a bullet-hell run."
	},
	
	"Bullets No, Brains!": {
		"completed": false,
		"description": "Last more than 4 minutes in a bullet-hell run."
	},
	
	"SO MUCH RED!": {
		"completed": false,
		"description": "Last more than 5 minutes in a bullet-hell run."
	},
	
	"Can't Touch This!": {
		"completed": false,
		"description": "Last more than 6 minutes in a bullet-hell run."
	},
	
	"Help! A Stalker!": {
		"completed": false,
		"description": "Evade the goal for 20 seconds!"
	},
	
	"Waste No Time!": {
		"completed": false,
		"description": "Hit the goal as soon as it's ready."
	},
	
	"Fake Out!": {
		"completed": false,
		"description": "Clash with a single faker enemy 6 times."
	},
}

const ENDLESS_ACHIEVEMENTS = [
	"First Of Many!", "Voluntary Celibate!", "Okay You're Pretty Bad!",
	"Okay, You're Pretty Good!", "Okay, You're Very Good!", "Okay, You're Very Good!",
	"Okay, You're Too Good!", "Okay, You Can Stop Now!", "Tryhard!",
	"Maybe You Should Go Outside!", "They're In The Walls!", "Very Nice!"
]
const BULLETHELL_ACHIEVEMENTS = [
	"Straight Up Ballin!", "Flashing Before My Eyes!", "That One Hurt!",
	"Bullets, No Brains!", "Slippery Fella!", "Untouchable!",
	"Bullets No, Brains!", "SO MUCH RED!", "Can't Touch This!",
	"Help! A Stalker!", "Waste No Time!", "Fake Out!"
]

var ACHIEVEMENT_KEYS: Array

signal achievement_complete(name: String, description: String)

const SAVE_PATH = "user://achievements.cfg"
const VARAIBLE_SECTION = "TRACKERS"
const ACHIEVEMENT_SECTION = "ACHIEVEMENTS"
#const SAVE_PASSWORD = "SiLLY :3"

# RUN-BOUND VARIABLES
var ball_hits: int = 0:
	set(new_ball_hits):
		ball_hits = new_ball_hits
		if ball_hits == 6:
			if wall_hits == 0:
				complete("They're In The Walls!")
var score: int = 0
var wall_hits: int = 0

var bullet_score: int = 0

func _ready() -> void:
	ACHIEVEMENT_KEYS = ACHIEVEMENTS.keys()

func reset_run_bounds() -> void:
	score = 0
	wall_hits = 0
	ball_hits = 0

func reset_bullet_run_bounds() -> void:
	pass

func save_achievements() -> void:
	var config = ConfigFile.new()
	
	config.set_value(ACHIEVEMENT_SECTION, "achievements", ACHIEVEMENTS)
	
	#config.save_encrypted_pass(SAVE_PATH, SAVE_PASSWORD)
	config.save(SAVE_PATH)

func load_achievements() -> void:
	var config = ConfigFile.new()
	#var error = config.load_encrypted_pass(SAVE_PATH, SAVE_PASSWORD)
	var error = config.load(SAVE_PATH)
	
	if error != OK:
		return
	
	ACHIEVEMENTS = config.get_value(ACHIEVEMENT_SECTION, "achievements", ACHIEVEMENTS)
	
	var endless_high = Global.endless_highs[0][0]
	
	if endless_high > 0:
		complete("First Of Many!")
	
	if endless_high < 1000:
		complete("Okay You're Pretty Bad!")
	
	if endless_high >= 25_000:
		complete("Okay, You're Pretty Good!")
	if endless_high >= 50_000:
		complete("Okay, You're Very Good!")
	if endless_high >= 75_000:
		complete("Okay, You're Too Good!")
	if endless_high >= 100_000:
		complete("Okay, You Can Stop Now!")
	if endless_high >= 150_000:
		complete("Tryhard!")
	if endless_high >= 200_000:
		complete("Maybe You Should Go Outside!")
	
	if str(endless_high).contains("69"):
		complete("Very Nice!")
	
	var bullet_high = Global.bullet_highs[0]
	
	if bullet_high > 0:
		complete("That One Hurt!")
	
	if bullet_high >= 60:
		complete("Bullets, No Brains!")
	if bullet_high >= 120:
		complete("Slippery Fella!")
	if bullet_high >= 180:
		complete("Untouchable!")
	if bullet_high >= 240:
		complete("Bullets No, Brains!")
	if bullet_high >= 300:
		complete("SO MUCH RED!")
	if bullet_high >= 360:
		complete("Can't Touch This!")

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
	
	if Global.endless_highs[0][0] > 0:
		complete("First Of Many!")
	
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
	
	if str(score).contains("69"):
		complete("Very Nice!")

func check_bullet_gameover() -> void:
	if Global.bullet_highs[0] > 0:
		complete("That One Hurt!")
	
	if bullet_score >= 60:
		complete("Bullets, No Brains!")
	if bullet_score >= 120:
		complete("Slippery Fella!")
	if bullet_score >= 180:
		complete("Untouchable!")
	if bullet_score >= 240:
		complete("Bullets No, Brains!")
	if bullet_score >= 300:
		complete("SO MUCH RED!")
	if bullet_score >= 360:
		complete("Can't Touch This!")
