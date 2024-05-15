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

var dunked: bool = false

var wind_momma: WindMomma

func _ready() -> void:
	wind_momma = get_tree().get_first_node_in_group("wind_momma")
	wind_momma.wind_updated.connect(update_wind)
	
	add_constant_central_force(wind_momma.wind_direction * wind_momma.wind_speed)
	
	player = get_tree().get_first_node_in_group("player")

func update_wind(direction: Vector2, speed: float) -> void:
	constant_force = Vector2.ZERO
	add_constant_central_force(direction * speed)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	collision_shape.set_deferred("disabled", false)

func die() -> void:
	if not dead:
		shape.modulate = Color.GREEN
		collision_shape.set_deferred("disabled", true)
		die_particles.restart()
		state_machine.transition_to("Died")
		dead = true


func _on_dunkin_area_entered(area: Area2D) -> void:
	if dunked:
		print("DUNKED")
		AchievementHandler.complete("Straight Up Ballin!")
