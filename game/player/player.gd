extends RigidBody2D

signal bumped_wall(direction: Vector2)

@export var speed: float = 500.0

func _physics_process(delta: float) -> void:
	var move_dir: Vector2 = get_move_dir()
	if move_dir.length() > 0:
		apply_central_impulse(
			get_move_dir() * speed * delta
		)
	else:
		pass

func get_move_dir() -> Vector2:
	return Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down"
	)

func _on_bumper_body_exited(body: Node2D) -> void:
	emit_signal("bumped_wall", linear_velocity)
