extends EnemyBase

var shoot_target = null

func _weapon_pos():
	if shoot_target == null:
		return

	if shoot_target.global_position.x > self.global_position.x:
		direction = 1
	else:
		direction = -1

	if direction < 0:
		$Pistol.flip_v = true
	else:
		$Pistol.flip_v = false

	# Set weapon position
	var offset = 100 * direction
	$Pistol.position.x = $Body.texture.get_width() * direction - offset

func _child_ready():
	pass

func _child_change_direction():
	pass

func _child_physics_process(_delta):
	if shoot_target != null:
		_weapon_pos()
		$Pistol.look_at(shoot_target.global_position)
		$Pistol.shoot(shoot_target)

func _on_player_body_entered(body):
	$Pistol.look_at(body.global_position)
	shoot_target = body
	speed = 0


func _on_player_body_exited(_body):
	shoot_target = null
	speed = 50
	if $Pistol.flip_v:
		$Pistol.rotation = 180 - 45
	else:
		$Pistol.rotation = 0.0
