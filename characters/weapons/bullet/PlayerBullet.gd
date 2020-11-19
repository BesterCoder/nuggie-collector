extends Area2D

const SPEED = 1000

var direction = Vector2(0.0, 0.0)

func initialize(_direction: Vector2):
	self.direction = _direction


func _physics_process(delta):
	position += SPEED * delta * direction

func _on_body_entered(_body):
	queue_free()

