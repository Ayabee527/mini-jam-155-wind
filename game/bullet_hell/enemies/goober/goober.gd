class_name GooberEnemy
extends RigidBody2D

@export var state_machine: StateMachine
@export var shape: Polygon2D
@export var bullet_spawner: Marker2D
@export var bullet_charge: GPUParticles2D
@export var thruster: GPUParticles2D

@export var collision_shape: CollisionShape2D

@export var die_particles: GPUParticles2D

var player: Player
var dead: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	collision_shape.set_deferred("disabled", false)

func die() -> void:
	if not dead:
		collision_shape.set_deferred("disabled", true)
		die_particles.restart()
		state_machine.transition_to("Died")
		dead = true
