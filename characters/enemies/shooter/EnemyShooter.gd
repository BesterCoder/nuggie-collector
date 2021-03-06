extends EnemyBase

enum {
	WEAPON_PISTOL = 1,
	WEAPON_RIFLE = 2,
	WEAPON_SHOTGUN = 3
}

# [DMG, HP]
const STATS = [
	[10, 1],
	[20, 2],
	[30, 3],
	[40, 4],
	[50, 6],
	[70, 8],
	[115, 12],
	[170, 18],
	[260, 26]
]

export var shoot_radius: float = 2000
export(int, "None", "Pistol", "Rifle", "Shotgun") var weapon_type: int = WEAPON_PISTOL


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
	$PlayerDetector/CollisionShape2D.shape = CircleShape2D.new()
	$PlayerDetector/CollisionShape2D.shape.set_radius(shoot_radius)
	var level = Level.get_current_level()
	hp_amount = STATS[level - 1][1]
	current_hp = hp_amount
	damage_amount = STATS[level - 1][0]
	$Pistol.visible = false
	$Rifle.visible = false
	$Rifle.set_infinite_ammo()
	$Shotgun.visible = false
	$Shotgun.set_infinite_ammo()

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
