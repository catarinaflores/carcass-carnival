extends Node2D

@export var bullet_scene: PackedScene  # Assign bullet scene in Inspector


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_handle_shooting()



func _handle_shooting() -> void:
	if !bullet_scene:
		push_warning("Bullet scene is null! Check the Inspector.")
		return
		
	if Input.is_action_pressed("shoot"):
		print("Shott2")
		_shoot()
		

func _shoot():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)

		bullet.position = global_position
		var bullet_direction = Vector2.RIGHT.rotated(randf() * TAU)
		bullet.shoot(bullet_direction)
