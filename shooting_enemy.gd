extends Area2D


@export var speed := 100
@export var fire_rate := 0.5  # Time between shots (seconds)
@onready var player: Area2D = $"../Player"
@onready var timer = $Timer
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var bullet = preload("res://scenes/enemy_bullet.tscn").instantiate()
var direction := Vector2.ZERO

func _ready():
	randomize()
	_choose_random_direction()
	timer.wait_time = fire_rate
	timer.start()

func _process(delta):
	position += direction * speed * delta

# Pick a new random movement direction
func _choose_random_direction():
	print("direction chosen")
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

# Shoot at the player
func _on_timer_timeout():
	print("timer timout")
	_shoot()

func _shoot():
	print("shoot")
	bullet = preload("res://scenes/enemy_bullet.tscn").instantiate()
	bullet.position.x = position.x
	bullet.position.y = position.y
	get_tree().get_root().add_child(bullet)
	var bullet_direction = (player.global_position - global_position).normalized()
	bullet.shoot(bullet_direction)
# 🚀 **Destroy enemy when it leaves the screen**

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("fuck off")
	queue_free()
