class_name PounderEnemyState
extends State

var enemy: PounderEnemy

func _ready() -> void:
	await owner.ready
	enemy = owner as PounderEnemy
	assert(enemy != null)
