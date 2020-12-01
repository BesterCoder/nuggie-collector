extends Area2D


func _on_body_entered(body):
	if body.deal_damage(-20):
		queue_free()
