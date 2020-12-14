extends EnemyBase

const STATS = [
	[20, 2],
	[30, 3],
	[40, 5],
	[70, 7],
	[100, 11],
	[150, 16],
	[230, 23],
	[340, 35],
	[510, 52]
]

func _child_ready():
	var level = Level.get_current_level()
	hp_amount = STATS[level - 1][1]
	current_hp = hp_amount
	damage_amount = STATS[level - 1][0]

	if moving:
		$SlimeAnimation.play("moving")

	if direction == DIR_LEFT:
		$SlimeAnimation.flip_h = true
		$HealthBar.rect_position.x = -20


func _child_change_direction():
	$SlimeAnimation.flip_h = not $SlimeAnimation.flip_h
	$HealthBar.rect_position.x = -20 if $SlimeAnimation.flip_h else -8


func _child_physics_process(_delta):
	pass

func _on_player_body_entered(body):
	body.deal_damage(damage_amount, global_position.x)
