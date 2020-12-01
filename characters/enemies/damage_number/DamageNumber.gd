extends Area2D

var damage_amount = 0

var xspeed = 100
var yspeed = -100

func initialize(pos: Vector2, damage: int, direction: int):
	$Label.text = String(damage)
	self.global_position = pos
	damage_amount = damage
	xspeed *= direction

func _physics_process(delta):
	yspeed += 10
	self.global_position.y += (yspeed * delta)
	self.global_position.x += (xspeed * delta)

func _on_floor_hit(_body):
	queue_free()
