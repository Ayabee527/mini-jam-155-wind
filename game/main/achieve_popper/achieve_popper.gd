extends VBoxContainer

const ACHIEVE_BOX = preload("res://main_menu/achievement_menu/achievement_slot/achieve_box.tscn")

@export var achieve_sound: AudioStreamPlayer

var queue = []

func _ready() -> void:
	AchievementHandler.achievement_complete.connect(add_to_queue)

func add_to_queue(aname: String, desc: String) -> void:
	queue.append( {"name": aname, "description": desc} )
	
	if not get_child_count() > 1:
		advance_queue()

func advance_queue() -> void:
	if not queue.size() > 0:
		return
	
	var queued = queue.pop_front()
	var box = ACHIEVE_BOX.instantiate()
	box.achieved = true
	box.name = queued["name"]
	box.achievement_name = queued["name"]
	box.achievement_description = queued["description"]
	add_child(box)
	achieve_sound.play()
	
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	tween.tween_property(
		box, "modulate:a", 0.0, 5.0
	)
	tween.play()
	tween.finished.connect(
		func():
			box.queue_free()
			await get_tree().create_timer(1.0).timeout
			advance_queue()
	)
