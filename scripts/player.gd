extends Area2D

# Signals
signal hit

# Export variables for easy configuration in editor
@export var speed: float = 400.0
@export var fire_rate: float = 0.5  # Time between shots in seconds
@export var bullet_scene: PackedScene  # Assign bullet scene in Inspector

# Member variables
var screen_size: Vector2
var can_shoot: bool = true

# Node references using onready
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var shoot_timer: Timer = $Timer

func _ready() -> void:
	# Initialize screen boundaries
	screen_size = get_viewport_rect().size
	
	# Verify Timer node
	if !shoot_timer:
		push_error("Timer node not found! Please add a Timer node as child of the Player.")
		return
		
	# Print debug info about bullet scene
	print("Bullet scene status: ", bullet_scene != null)
	if bullet_scene:
		print("Bullet scene path: ", bullet_scene.resource_path)
	
	# Setup shooting timer
	shoot_timer.wait_time = fire_rate
	shoot_timer.one_shot = true
	
	
	 # Debug Timer connection
	print("Timer node reference: ", shoot_timer)
	print("Timer wait time: ", shoot_timer.wait_time)
	print("Timer one shot: ", shoot_timer.one_shot)
	
	# Verify signal connection
	print("Timer timeout connected: ", shoot_timer.timeout.get_connections().size() > 0)

func _process(delta: float) -> void:
	_handle_movement(delta)
	_handle_shooting()
	_update_animation()

func _handle_movement(delta: float) -> void:
	# Get input vector
	var velocity = Vector2.ZERO
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	
	# Normalize and apply speed
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	# Update position while keeping within screen bounds
	position += velocity * delta
	print(screen_size)
	position = position.clamp(Vector2.ZERO, screen_size)

func _handle_shooting() -> void:
	if !bullet_scene:
		push_warning("Bullet scene is null! Check the Inspector.")
		return
		
	if Input.is_action_pressed("shoot") and can_shoot:
		_shoot()
		can_shoot = false
		print("Started shoot timer")
		shoot_timer.start()

func _shoot() -> void:
	# Double check bullet_scene
	if !is_instance_valid(bullet_scene) or !bullet_scene:
		push_warning("Bullet scene not set!")
		return
		
	# Create bullet instance
	var bullet = bullet_scene.instantiate()
	if !bullet:
		push_error("Failed to instantiate bullet scene!")
		return
		
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	
	# Calculate shooting direction towards mouse
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	# Set bullet rotation to face direction
	bullet.rotation = direction.angle()
	
	# Shoot the bullet
	bullet.shoot(direction)
	
	$AudioStreamPlayerDarts.play()

func _update_animation() -> void:
	# Get direction to mouse for character facing
	var mouse_direction = (get_global_mouse_position() - position).normalized()
	
	# Determine animation based on mouse direction
	if abs(mouse_direction.x) > abs(mouse_direction.y):
		# Horizontal movement
		sprite.flip_h = mouse_direction.x < 0
		sprite.play("right" if _is_moving() else "right")
	else:
		# Vertical movement
		if mouse_direction.y < 0:
			sprite.play("back" if _is_moving() else "back")
		else:
			sprite.play("front" if _is_moving() else "front")

func _is_moving() -> bool:
	# Helper function to check if player is moving
	return Input.get_vector("move_left", "move_right", "move_up", "move_down").length() > 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy_projectiles"):
		print("Something hit the player. Auch")
		handle_death()

func handle_death() -> void:
	# Disable player movement
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	
	# Hide player and disable collision
	hide()
	hit.emit()
	collision_shape.set_deferred("disabled", true)

	# Play death sound
	$AudioStreamPlayer2D.play()

	# Stop enemies from shooting at the player
	get_tree().call_group("enemies", "stop_shooting")

	# Wait for sound to finish
	await get_tree().create_timer(1.5).timeout  

	# Change to death scene
	#get_tree().change_scene_to_file("res://scenes/death_scene.tscn")

	# Wait before transitioning to main menu
	await get_tree().create_timer(3.0).timeout  
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
	# Restore player when returning to menu
	reset_player()

func reset_player() -> void:
	# Enable player processing
	set_process(true)
	set_physics_process(true)
	set_process_input(true)

	# Show player and enable collision
	show()
	collision_shape.set_deferred("disabled", false)

func _on_shoot_timer_timeout() -> void:
	print("Timer triggered. Player can shoot")
	can_shoot = true
