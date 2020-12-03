extends Area2D

signal nuggie_collected(nuggie_position)

# TODO: add a bright "halo" on back of the nuggie
# so they seem more heavenly
func _ready():
	$AnimationPlayer.play("hover")


func _on_body_entered(_body):
	emit_signal("nuggie_collected", global_position)
	queue_free()
