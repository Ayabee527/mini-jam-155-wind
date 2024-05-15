class_name PlayerGoal
extends RigidBody2D

const EXPLOSION = preload("res://goal/hazards/explosion/explosion.tscn")

const BULLET = preload("res://goal/hazards/bullet/bullet.tscn")
const SAW = preload("res://goal/hazards/saw/saw.tscn")
const BOMB = preload("res://goal/hazards/bomb/bomb.tscn")
const BARRIER = preload("res://goal/hazards/barrier/barrier.tscn")

const HAZARDS = {
	"BULLET": BULLET,
	"SAW": SAW,
	"BOMB": BOMB,
	"BARRIER": BARRIER
}

const COSTS = {
	"BULLET": 2,
	"SAW": 6,
	"BARRIER": 9,
	"BOMB": 10,
}

const EXPLOSION_COST = 5

signal collected()

@export var stun_timer: Timer
@export var shape: Polygon2D

@export var collision: CollisionShape2D
@export var player_collision: CollisionShape2D

@export var collect_particles: GPUParticles2D

@export var explod_sound: AudioStreamPlayer
@export var yipee_sound: AudioStreamPlayer

var combo: int = 0

var velocity: Vector2

var wind_momma: WindMomma

func _ready() -> void:
	wind_momma = get_tree().get_first_node_in_group("wind_momma")
	wind_momma.wind_updated.connect(update_wind)

func _physics_process(delta: float) -> void:
	apply_central_force(velocity)

func update_wind(direction: Vector2, speed: float) -> void:
	constant_force = Vector2.ZERO
	add_constant_central_force(direction * speed)

func show_collect() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		shape, "modulate",
		Color(1, 1, 1, 1), 3.0
	).from(Color(0, 1, 0, 0.5))
	tween.tween_property(
		shape, "scale",
		Vector2.ONE, 3.0
	).from(Vector2.ONE * 2.0)
	tween.play()
	
	collect_particles.restart()
	explod_sound.play()
	yipee_sound.play()

func explode() -> void:
	var owies = get_tree().get_nodes_in_group("owies")
	for owie: Node2D in owies:
		if owie.has_method("die"):
			owie.die()
		else:
			owie.queue_free()
	
	var score: int = combo
	
	var chosens: Array = []
	
	var hazards: Array = COSTS.keys().duplicate()
	var score_out: bool = false
	while score > 0:
		hazards = COSTS.keys().duplicate()
		
		hazards.shuffle()
		var chosen_hazard = hazards.pop_back()
		
		while (COSTS[chosen_hazard] > score):
			if hazards.size() == 0:
				score_out = true
				break
			
			chosen_hazard = hazards.pop_back()
		
		if score_out:
			break
		
		score -= COSTS[chosen_hazard]
		
		if not chosen_hazard in ["BARRIER"]:
			if score >= EXPLOSION_COST:
				if randf() <= 0.5:
					chosen_hazard += "*"
					score -= EXPLOSION_COST
		
		chosens.append(chosen_hazard)
	
	for name: String in chosens:
		var explodes = name.contains("*")
		var hazard_name = name.trim_suffix("*")
		var hazard: RigidBody2D = HAZARDS[hazard_name].instantiate()
		hazard.global_position = global_position
		var ang_offset = randf_range(-PI/4, PI/4)
		var dir := linear_velocity.normalized().rotated(PI).rotated(ang_offset)
		var speed := randf_range(50, 150)
		hazard.apply_central_impulse(
			dir * speed
		)
		
		if explodes:
			var explosion = EXPLOSION.instantiate()
			explosion.final_radius = randi_range(24, 64)
			explosion.time_to_full = randf_range(2.5, 10.0)
			explosion.linger_time = 1.5
			hazard.add_child(explosion)
			explosion.exploded.connect(
				func():
					if "freeze" in hazard:
						hazard.set_deferred("freeze", true)
					if "shape" in hazard:
						hazard.shape.hide()
			)
			explosion.tree_exiting.connect(
				func():
					hazard.queue_free()
			)
		
		get_tree().current_scene.add_child(hazard)

func die() -> void:
	collision.set_deferred("disabled", true)
	player_collision.set_deferred("disabled", true)
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		shape, "modulate",
		Color(1, 1, 1, 0), 5.0
	)

func _on_player_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		if stun_timer.is_stopped():
			combo += 1
			
			stun_timer.start()
			show_collect()
			collected.emit()
			
			var dir_to_player := global_position.direction_to(
				body.global_position
			)
			apply_central_impulse(dir_to_player.rotated(PI) * 500.0)
			body.apply_central_impulse(dir_to_player * 750.0)
			explode()


func _on_move_timer_timeout() -> void:
	var speed: float = randf_range(25, 250)
	var dir: Vector2 = Vector2.from_angle(TAU * randf())
	dir += constant_force.normalized() * 0.5
	dir = dir.normalized()
	
	velocity = dir * speed
