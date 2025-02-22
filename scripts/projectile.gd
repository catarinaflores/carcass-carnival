extends Area2D

@export var speed: float = 300.0
var direction := Vector2.ZERO

func _process(delta):
	position += direction * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
