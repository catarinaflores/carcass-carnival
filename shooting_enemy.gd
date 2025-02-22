extends Area2D


@export var speed := 100
@export var fire_rate := 2.0  # Time between shots (seconds)
@export var bullet_scene: PackedScene  # Assign your bullet scene in the Inspector

var direction := Vector2.ZERO
var player: Node2D

@onready var timer = $Timer
@onready var visible_on_screen_notifier_2d = %VisibleOnScreenNotifier2D


func _ready():
	randomize()
	_choose_random_direction()
	timer.wait_time = fire_rate
	timer.start()

func _process(delta):
	position += direction * speed * delta

# Pick a new random movement direction
func _choose_random_direction():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

# Shoot at the player
func _on_timer_timeout():
	if player and is_instance_valid(player):
		_shoot()

func _shoot():
	if bullet_scene and player:
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)

		bullet.position = global_position
		var bullet_direction = (player.global_position - global_position).normalized()
		bullet.shoot(bullet_direction)

# 🚀 **Destroy enemy when it leaves the screen**
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# Detect the player when entering the scene
func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
