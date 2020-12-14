extends Area2D


func _on_body_entered(body):
	# Player should never have over 9000 health
	body.deal_damage(9001)
