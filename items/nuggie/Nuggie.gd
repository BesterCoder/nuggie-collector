extends Area2D

# TODO: add a bright "halo" on back of the nuggie
# so they seem more heavenly
func _ready():
	$AnimationPlayer.play("hover")


func _on_body_entered(_body):
	queue_free()
