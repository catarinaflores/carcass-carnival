extends Area2D

@onready var player: Area2D = $"../Player"
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var explode = preload("res://scenes/explosion.tscn").instantiate()

const XplosionDistance = 100
var speed = 200
var previous_position: Vector2

func _ready():
	previous_position = position  # Initialize previous position

func _process(delta: float) -> void:
	var move_direction = (player.position - position).normalized()

	explode.position = position
	if (player.position - position).length() < XplosionDistance:
		get_tree().get_root().add_child(explode)
		queue_free()
		return

	previous_position = position  # Store current position before moving

	# Move towards player
	position += move_direction * speed * delta

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
