extends Area2D

signal hit

@export var speed := 400
var scree_size: Vector2

@onready var animated_sprite_2d = %AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	scree_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2()  # The player's movement vector.
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	else:
		animated_sprite_2d.play("idle")

	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, scree_size)
	
	var mouse_pos = get_global_mouse_position()
	rotation = (mouse_pos - position).angle()
