extends BaseItem


func _on_body_entered(body):
	if body.name == "Player":
		if body.deal_damage(-20):
			queue_free()
	else:
		global_position.y -= 20
		yspeed = 0
