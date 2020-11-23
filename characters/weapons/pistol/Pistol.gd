extends WeaponBase

func _ready():
	set_infinite_ammo()
	set_shoot_wait_time(0.4)

# Called from WeaponBase shoot function
func weapon_shoot():
	var point_position = $BulletPoint.global_position
	# TODO: cleaner way to change the y position when weapon is flipped
	if self.flip_v:
		$BulletPoint.position.y *= -1
		point_position = $BulletPoint.global_position
		$BulletPoint.position.y *= -1

	var new_bullet = weapon_bullet.instance()
	new_bullet.initialize((get_global_mouse_position() - global_position).normalized())
	new_bullet.global_position = point_position

	get_tree().current_scene.add_child(new_bullet)
