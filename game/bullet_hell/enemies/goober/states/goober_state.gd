class_name GooberEnemyState
extends State

var enemy: GooberEnemy

func _ready() -> void:
	await owner.ready
	enemy = owner as GooberEnemy
	await(enemy != null)
