extends RigidBody2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	$"%AudioStreamPlayer2D".play()
	timer.start()
	
	

func _on_timer_timeout():
	queue_free()
