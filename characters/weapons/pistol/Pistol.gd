extends Sprite

export var weapon_bullet: PackedScene

var shoot_timer = null
var shoot_ready = true

func _ready():
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.wait_time = 0.4
	shoot_timer.connect("timeout", self, "_on_shoot_ready")

func _on_shoot_ready():
	shoot_ready = true

func shoot():
	if not shoot_ready:
		return
	shoot_ready = false


	var point_position = $BulletPoint.global_position
	# TODO: cleaner way to change the y position when weapon is flipped
	if self.flip_v:
		$BulletPoint.position.y *= -1
		point_position = $BulletPoint.global_position
		$BulletPoint.position.y *= -1

	var new_bullet = weapon_bullet.instance()
	new_bullet.initialize((get_global_mouse_position() - global_position).normalized())
	new_bullet.global_position = point_position

	get_tree().current_scene.add_child(new_bullet)
	shoot_timer.start()
