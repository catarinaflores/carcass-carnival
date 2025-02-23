extends Node2D

@export var shooting_enemy_scene: PackedScene  # Assign the Mob scene in the Inspector
@export var exploding_enemy_scene: PackedScene  # Assign the Mob scene in the Inspector

@export var spawn_area: Node2D      # Optional: A Node2D defining spawn bounds

func _ready():
	$Timer.timeout.connect(spawn_mob)
	$Timer.start(2)  # Spawns every 2 seconds
	
	
func spawn_mob():
	if not shooting_enemy_scene or not exploding_enemy_scene:
		return
	
	$AudioStreamPlayer2D.play()
	
	# Randomly choose between the two enemy types
	var enemy_scene = shooting_enemy_scene if randi() % 2 == 0 else exploding_enemy_scene
	var enemy = enemy_scene.instantiate()

	# Default spawn position
	var spawn_position = position  

	# If using a spawn area, choose a random point inside it
	if spawn_area:
		spawn_position = spawn_area.global_position + Vector2(randf_range(-100, 100), randf_range(-100, 100))

	enemy.position = spawn_position
	get_parent().add_child(enemy)
	
	
