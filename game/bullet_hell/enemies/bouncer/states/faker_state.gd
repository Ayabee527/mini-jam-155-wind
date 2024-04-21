class_name FakerEnemyState
extends State

var enemy: FakerEnemy

func _ready() -> void:
	await owner.ready
	enemy = owner as FakerEnemy
	assert(enemy != null)
