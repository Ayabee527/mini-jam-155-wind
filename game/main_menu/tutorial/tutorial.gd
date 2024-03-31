extends Node2D

@export var text_label: RichTextLabel
@export var score_label: RichTextLabel

@export var player: Player
@export var player_goal: PlayerGoal
@export var wind_momma: WindMomma

var score: int = -1
var tutorial_index: int = 0

func _process(delta: float) -> void:
	match tutorial_index:
		0:
			check_moving()

func check_moving() -> void:
	if Input.get_vector("move_left", "move_right", "move_up", "move_down"):
		progress_tutorial()

func check_bump() -> void:
	pass

func progress_tutorial() -> void:
	tutorial_index += 1
	
	text_label.text = "[center]"
	match tutorial_index:
		1:
			text_label.text += "bumping into walls makes wind blow in that direction! try it out!"
		2:
			player_goal.show()
			text_label.text += "this is the goal! try hitting it!"
		3:
			score_label.show()
			text_label.text += "hitting the goal increases your score!"
		4:
			player_goal.combo = 6
			text_label.text += "hitting the goal will spawn hazards! you can pass through them if they're yellow but they are dangerous when they are red!"
		5:
			text_label.text += "the faster you or the goal is, the higher your score will get!"
		6:
			text_label.text += "thats all you need to know! have fun!!"
		7:
			SceneSwitcher.switch_to("res://main_menu/main_menu.tscn")


func _on_player_bumped_wall(direction: Vector2) -> void:
	wind_momma.wind_speed += direction.length()
	
	if abs( wind_momma.wind_direction.dot(direction.normalized()) ) > -0.5:
		wind_momma.wind_direction = direction.normalized()
	
	if tutorial_index == 1:
		progress_tutorial()


func _on_player_goal_collected() -> void:
	if tutorial_index > 1:
		progress_tutorial()
	
	if tutorial_index > 2:
		score += 1
		if tutorial_index == 6:
			score += 2
		score_label.text = "[center][shake rate=10 level=24]" + str(score)
