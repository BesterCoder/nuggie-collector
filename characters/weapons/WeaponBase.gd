extends Sprite

class_name WeaponBase

export var weapon_bullet: PackedScene

var shoot_timer = null
var shoot_ready = true

func _ready():
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.connect("timeout", self, "_on_shoot_ready")

func _on_shoot_ready():
	shoot_ready = true

func _start_shoot_timer():
	shoot_ready = false
	shoot_timer.start()

func shoot():
	if not shoot_ready:
		return
	weapon_shoot()
	_start_shoot_timer()

func weapon_shoot():
	var msg = "WeaponBase.gd: shoot_handler is not overridden"
	print(msg)
	push_error(msg)

func set_shoot_wait_time(time: float):
	shoot_timer.wait_time = time

