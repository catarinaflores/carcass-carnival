extends Area2D
@onready var player: Area2D = $"../Player"
const XplosionDistance = 100
var speed = 200
@onready var explode = preload("res://scenes/explosion.tscn").instantiate()

func _process(delta: float) -> void:
	explode.position.x = position.x
	explode.position.y = position.y
	if abs(player.position.x - position.x) + abs(player.position.y - position.y) < XplosionDistance:
		get_tree().get_root().add_child(explode)
		queue_free()
	else:
		if(player.position.x > position.x):
			position.x += speed * delta
		else:
			position.x -= speed * delta
		if(player.position.y > position.y):
			position.y += speed * delta
		else:
			position.y -= speed * delta
