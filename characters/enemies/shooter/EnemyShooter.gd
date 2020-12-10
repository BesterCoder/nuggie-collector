extends EnemyBase

enum {
	WEAPON_PISTOL = 1,
	WEAPON_RIFLE = 2,
	WEAPON_SHOTGUN = 3
}

export var weapon_type = 1

var shoot_target = null
var weapon = null

func _weapon_pos():
	if shoot_target == null:
		return

	if shoot_target.global_position.x > self.global_position.x:
		direction = 1
	else:
		direction = -1

	if direction < 0:
		weapon.flip_v = true
	else:
		weapon.flip_v = false

	# Set weapon position
	var offset = 100 * direction
	weapon.position.x = $Body.texture.get_width() * direction - offset

func _child_ready():
	$Pistol.visible = false
	$Rifle.visible = false
	$Shotgun.visible = false

	match weapon_type:
		WEAPON_PISTOL:
			weapon = $Pistol
		WEAPON_RIFLE:
			weapon = $Rifle
		WEAPON_SHOTGUN:
			weapon = $Shotgun
		_:
			push_error("EnemyShooter.gd: Invalid weapon_type: %d" % drop_type)

	weapon.visible = true



func _child_change_direction():
	pass

func _child_physics_process(_delta):
	if shoot_target != null:
		_weapon_pos()
		weapon.look_at(shoot_target.global_position)
		weapon.shoot(shoot_target, damage_amount)

func _on_player_body_entered(body):
	weapon.look_at(body.global_position)
	shoot_target = body
	speed = 0


func _on_player_body_exited(_body):
	shoot_target = null
	speed = 50
	if weapon.flip_v:
		weapon.rotation = 180 - 45
	else:
		weapon.rotation = 0.0
