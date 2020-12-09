extends EnemyBase


func _child_ready():

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
	body.deal_damage(20, global_position.x)
