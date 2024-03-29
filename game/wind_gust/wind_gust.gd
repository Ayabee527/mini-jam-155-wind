class_name WindGust
extends Line2D

@export var speed: float = 0
@export var direction: Vector2 = Vector2.RIGHT

var tail_end: Vector2 = Vector2.ZERO

var velocity: Vector2

func _ready() -> void:
	width = randi_range(1, 3)
	
	add_point(Vector2.ZERO)
	
	tail_end = direction.normalized().rotated(PI) * speed * 0.1
	
	add_point(tail_end)

func _process(delta: float) -> void:
	if speed > 0:
		tail_end = tail_end.move_toward(
			direction.normalized().rotated(PI) * speed * 0.1,
			75.0 * delta
		)
	else:
		tail_end = tail_end.move_toward(
			Vector2.ZERO,
			75.0 * delta
		)
	
	velocity = tail_end.direction_to(Vector2.ZERO) * speed
	global_position += velocity * delta
	
	points[1] = tail_end
	
	wrap_gust()

func wrap_gust() -> void:
	var speed_pardon: float = speed * 0.1
	if global_position.x < -speed_pardon:
		global_position.x = 256
	
	if global_position.y < -speed_pardon:
		global_position.y = 256
	
	if global_position.x >= 256 + speed_pardon:
		global_position.x = 0
	
	if global_position.y >= 256 + speed_pardon:
		global_position.y = 0
