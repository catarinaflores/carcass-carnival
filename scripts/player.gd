extends Area2D

signal hit

@export var speed := 400
var scree_size: Vector2

@onready var animated_sprite_2d = %AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	scree_size = get_viewport_rect().size


func _process(delta: float) -> void:
	var velocity = Vector2()  # The player's movement vector.

	# Movement input
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	# Normalize velocity and apply speed
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	# Apply movement
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, scree_size)

	# Get direction of the mouse relative to player
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - position  # Raw direction vector

	# Ensure direction is always valid
	if direction.length() > 5:  # Avoid near-zero movement errors
		direction = direction.normalized()
	else:
		direction = Vector2.ZERO  # Keep last valid direction (prevents flickering)

	# Determine animation based on direction & movement
	if abs(direction.x) > abs(direction.y): 
		# Horizontal direction (left/right)
		animated_sprite_2d.flip_h = direction.x < 0  # Flip when facing left
		if velocity.length() > 0:
			animated_sprite_2d.play("move_side")
		else:
			animated_sprite_2d.play("side_idle")
	else:
		# Vertical direction (up/down)
		if direction.y < 0:
			# Facing up
			if velocity.length() > 0:
				animated_sprite_2d.play("move_up")
			else:
				animated_sprite_2d.play("up_idle")
		else:
			# Facing down
			if velocity.length() > 0:
				animated_sprite_2d.play("move_down")
			else:
				animated_sprite_2d.play("down_idle")
