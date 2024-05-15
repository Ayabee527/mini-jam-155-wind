extends Node2D

const EXPLOSION = preload("res://goal/hazards/explosion/explosion.tscn")

const BULLET = preload("res://goal/hazards/bullet/bullet.tscn")
const SAW = preload("res://goal/hazards/saw/saw.tscn")
const BOMB = preload("res://goal/hazards/bomb/bomb.tscn")
const BARRIER = preload("res://goal/hazards/barrier/barrier.tscn")

const GOOBER = preload("res://bullet_hell/enemies/goober/goober.tscn")
const FAKER = preload("res://bullet_hell/enemies/faker/faker.tscn")
const POUNDER = preload("res://bullet_hell/enemies/pounder/pounder.tscn")

const PROJECTILES = [
	"BULLET", "SAW", "BOMB", "BARRIER"
]
const ENEMIES = [
	"GOOBER", "FAKER", "POUNDER"
]

const HAZARDS = {
	"BULLET": BULLET,
	"SAW": SAW,
	"BOMB": BOMB,
	"BARRIER": BARRIER,
	
	"GOOBER": GOOBER,
	"FAKER": FAKER,
	"POUNDER": POUNDER,
}

const COSTS = {
	"BULLET": 1,
	"SAW": 4,
	"BOMB": 5,
	"BARRIER": 8,
	
	"GOOBER": 2,
	"FAKER": 4,
	"POUNDER": 6,
}

const EXPLOSION_COST = 3

@export var extra_spend: int = 3

@export var enemy_spawner: PathFollow2D
@export var projectile_spawner: Marker2D

var progress: int = 0

func clear_hazards() -> void:
	var owies = get_tree().get_nodes_in_group("owies")
	for owie in owies:
		if owie.has_method("die"):
			owie.die()
		else:
			owie.queue_free()
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy: RigidBody2D in enemies:
		if enemy.has_method("die"):
			enemy.die()
		else:
			enemy.queue_free()

func spawn_hazards() -> void:
	var score: int = progress + extra_spend
	
	var chosens: Array = []
	var exploding: Array = []
	
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
		
		if chosen_hazard == "BARRIER":
			score += 3
		score -= COSTS[chosen_hazard]
		
		if not chosen_hazard in ["BARRIER", "POUNDER"]:
			if score >= EXPLOSION_COST:
				if randf() <= 0.5:
					chosen_hazard += "*"
					score -= EXPLOSION_COST
		
		chosens.append(chosen_hazard)
	
	for name: String in chosens:
		var explodes = name.contains("*")
		var hazard_name = name.trim_suffix("*")
		var hazard: RigidBody2D = HAZARDS[hazard_name].instantiate()
		if PROJECTILES.has(hazard_name):
			hazard.global_position = projectile_spawner.global_position
			
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
			
			var dir := Vector2.from_angle(TAU * randf())
			var speed := randf_range(50, 250)
			hazard.apply_central_impulse(
				dir * speed
			)
		else:
			enemy_spawner.progress_ratio = randf()
			hazard.global_position = enemy_spawner.global_position
			
			if explodes:
				var explosion = EXPLOSION.instantiate()
				explosion.final_radius = randi_range(24, 64)
				explosion.time_to_full = randf_range(2.5, 10.0)
				explosion.linger_time = 1.0
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

func _on_bullet_hell_goal_collected() -> void:
	progress += 1
	
	clear_hazards()
	spawn_hazards()
