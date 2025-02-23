extends Area2D


@export var speed := 100
@export var fire_rate := 0.5  # Time between shots (seconds)
@onready var player: Area2D = $"../Player"
@onready var timer = $Timer
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var bullet = preload("res://scenes/enemy_bullet.tscn").instantiate()

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D

var direction := Vector2.ZERO

func _ready():
	randomize()
	_choose_random_direction()
	timer.wait_time = fire_rate
	timer.start()

func _process(delta: float) -> void:
	var move_direction = (player.position - position).normalized()
	position += direction * speed * delta

	_update_animation(move_direction)

func _update_animation(move_direction: Vector2) -> void:
	if move_direction == Vector2.ZERO:
		return # Don't change animation if not moving

	if abs(move_direction.x) > abs(move_direction.y):
		# Moving horizontally
		sprite.flip_h = move_direction.x < 0
		#sprite.play("side")
	else:
		# Moving vertically
		if move_direction.y < 0:
			sprite.play("back")
		else:
			sprite.play("front")

# Pick a new random movement direction
func _choose_random_direction():
	print("direction chosen")
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

# Shoot at the player
func _on_timer_timeout():
	print("timer timout")
	_shoot()

func _shoot() -> void:
	print("shoot")
	
	# Preload bullet scene
	var bullet_scene = preload("res://scenes/enemy_bullet.tscn")
	var bullet = bullet_scene.instantiate()
	
	if !bullet:
		push_error("Failed to instantiate bullet scene!")
		return
	
	# Add bullet to the scene tree
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	
	# Set bullet scale (if you want to ensure it's unchanged)
	#bullet.scale = Vector2(1, 1)  # Set to default scale (can change this if needed)
	
	# Calculate shooting direction towards player
	var bullet_direction = (player.global_position - global_position).normalized()
	
	# Set bullet rotation to face direction
	bullet.rotation = bullet_direction.angle() + 3.1415
	
	# Shoot the bullet
	bullet.shoot(bullet_direction)
	
	$"AudioStreamPlayer2D".play()


#func _shoot():
	#print("shoot")
	#bullet = preload("res://scenes/enemy_bullet.tscn").instantiate()
	#bullet.position.x = position.x
	#bullet.position.y = position.y
	#get_tree().get_root().add_child(bullet)
	#var bullet_direction = (player.global_position - global_position).normalized()
	#bullet.shoot(bullet_direction)
## 🚀 **Destroy enemy when it leaves the screen**
#
#func _shoot() -> void:
	## Double check bullet_scene
	#if !is_instance_valid(bullet_scene) or !bullet_scene:
		#push_warning("Bullet scene not set!")
		#return
		#
	## Create bullet instance
	#var bullet = bullet_scene.instantiate()
	#if !bullet:
		#push_error("Failed to instantiate bullet scene!")
		#return
		#
	#get_parent().add_child(bullet)
	#bullet.global_position = global_position
	#
	## Calculate shooting direction towards mouse
	#var mouse_pos = get_global_mouse_position()
	#var direction = (mouse_pos - global_position).normalized()
	#
	## Set bullet rotation to face direction
	#bullet.rotation = direction.angle()
	#
	## Shoot the bullet
	#bullet.shoot(direction)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("fuck off")
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
