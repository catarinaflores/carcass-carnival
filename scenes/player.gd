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
	var velocity := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if velocity.x != 0:
		animated_sprite_2d.animation = "moving_horizontal"
		animated_sprite_2d.flip_v = false
		animated_sprite_2d.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animated_sprite_2d.animation = "moving_vertical"
		animated_sprite_2d.flip_v = velocity.y > 0
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, scree_size)
