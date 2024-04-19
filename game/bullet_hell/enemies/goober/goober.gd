class_name GooberEnemy
extends RigidBody2D

@export var bullet_spawner: Marker2D
@export var bullet_charge: GPUParticles2D
@export var thruster: GPUParticles2D

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
