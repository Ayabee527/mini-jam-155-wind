extends ColorRect

@export var animation_player: AnimationPlayer

var scene_path: String

func switch_to(path: String):
	scene_path = path
	switch_out()

func load_scene() -> void:
	get_tree().change_scene_to_file(scene_path)

func switch_out() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	rotation = 0
	animation_player.play("switch_out")

func switch_in() -> void:
	rotation = PI
	animation_player.play("switch_in")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"switch_out":
			load_scene()
			switch_in()
		"switch_in":
			mouse_filter = Control.MOUSE_FILTER_IGNORE
