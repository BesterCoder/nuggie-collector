extends Area2D

const SPEED = 1000
# Max distance in pixels
const MAX_DISTANCE = 5000

var direction = Vector2(0.0, 0.0)
var start_pos = null
var damage: int = 0

func initialize(global_pos: Vector2, _direction: Vector2, _damage: int = 1):
	self.direction = _direction
	self.start_pos = global_pos
	self.global_position = global_pos
	self.damage = _damage

func _physics_process(delta):
	self.global_position += SPEED * delta * direction

	var xdistance = abs(global_position.x - start_pos.x)
	var ydistance = abs(global_position.y - start_pos.y)
	if xdistance >= MAX_DISTANCE or ydistance >= MAX_DISTANCE:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.hurt()
	queue_free()

