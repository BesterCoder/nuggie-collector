extends Sprite

class_name WeaponBase

signal weapon_shot(weapon)

export var weapon_bullet: PackedScene

var shoot_timer = null
var shoot_ready = true
var max_ammo = 0
var current_ammo = 0
var infinite_ammo = false

func _ready():
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.connect("timeout", self, "_on_shoot_ready")

func _on_shoot_ready():
	shoot_ready = true

func _start_shoot_timer():
	shoot_ready = false
	shoot_timer.start()

# Add ammo if the current_ammo isn't maxed out
# return true if ammo is added
func add_ammo(amount: int) -> bool:
	if current_ammo == max_ammo:
		return false

	current_ammo += amount
	if current_ammo > max_ammo:
		current_ammo = max_ammo

	return true

func shoot():
	if not shoot_ready:
		return
	if not infinite_ammo and current_ammo < 1:
		return

	current_ammo -= 1
	weapon_shoot()
	emit_signal("weapon_shot", self)
	_start_shoot_timer()

func weapon_shoot():
	var msg = "WeaponBase.gd: shoot_handler is not overridden"
	print(msg)
	push_error(msg)

func set_shoot_wait_time(time: float):
	shoot_timer.wait_time = time

func set_ammo_amounts(_current_ammo: int, _max_ammo: int):
	self.max_ammo = _max_ammo
	self.current_ammo = _current_ammo

func set_infinite_ammo():
	self.infinite_ammo = true
