extends Area2D

class_name BaseItem

var yspeed = 100

func _physics_process(delta):
	self.global_position.y += (yspeed * delta)
