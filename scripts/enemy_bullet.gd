extends RigidBody2D

@export var speed := 800  # Adjust bullet speed as needed
@export var lifetime := 1.0  # Bullet disappears after this time

func _ready():
	# Automatically delete the bullet after a set time
	$Timer.wait_time = lifetime
	$Timer.start()

func shoot(dir: Vector2):
	# Set the bullet velocity
	linear_velocity = dir.normalized() * speed

# Destroy the bullet when it leaves the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	print("out screen")
	queue_free()

func _on_body_entered():
	print("hit player")
	queue_free()


func _on_timer_timeout():
	print("time out")
	queue_free()
