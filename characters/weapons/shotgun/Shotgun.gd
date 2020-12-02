extends WeaponBase

const rotation_map = [
	deg2rad(15),
	deg2rad(7.5),
	deg2rad(0),
	deg2rad(-15),
	deg2rad(-7.5),
]

func _ready():
	set_ammo_amounts(10, 10)
	set_shoot_wait_time(0.4)

# Called from WeaponBase shoot function
func weapon_shoot(target):
	var target_pos = get_global_mouse_position()
	if target != null:
		target_pos = target.global_position

	var point_position = $BulletPoint.global_position
	# TODO: cleaner way to change the y position when weapon is flipped
	if self.flip_v:
		$BulletPoint.position.y *= -1
		point_position = $BulletPoint.global_position
		$BulletPoint.position.y *= -1

	var normalized_vector = (target_pos - global_position).normalized()
	for rotation in rotation_map:
		var new_bullet = weapon_bullet.instance()
		new_bullet.initialize(point_position, normalized_vector.rotated(rotation))
		get_tree().current_scene.add_child(new_bullet)
