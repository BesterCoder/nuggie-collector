extends Area2D

class_name BaseItem

var yspeed = 100

func initialize(pos: Vector2, item_type: int = 1):
	self.global_position = pos
	if item_type == 2:
		set_ammo_as_rifle()
	pass

func _physics_process(delta):
	self.global_position.y += (yspeed * delta)

# Function for ammo item.
# TODO: figure out cleaner way to do this
func set_ammo_as_rifle():
	pass
