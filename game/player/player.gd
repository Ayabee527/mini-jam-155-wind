class_name Player
extends RigidBody2D

signal bumped_wall(direction: Vector2)

@export var speed: float = 500.0

@export_group("Inner Dependencies")
@export var bump_sound: AudioStreamPlayer

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var move_dir: Vector2 = get_move_dir()
	if move_dir.length() > 0:
		apply_central_force(
			get_move_dir() * speed
		)
	else:
		pass

func get_move_dir() -> Vector2:
	return Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down"
	)

func _on_bumper_body_entered(body: Node2D) -> void:
	emit_signal("bumped_wall", linear_velocity)


func _on_body_entered(body: Node) -> void:
	bump_sound.play()
