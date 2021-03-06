extends Sprite

class_name WeaponBase

signal weapon_ammo_changed(weapon)

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
func add_ammo(amount: int, weapon_equipped: bool) -> bool:
	if current_ammo == max_ammo:
		return false

	current_ammo += amount
	if current_ammo > max_ammo:
		current_ammo = max_ammo

	if weapon_equipped:
		emit_signal("weapon_ammo_changed", self)
	return true

func shoot(target = null, damage: int = 1):
	if not shoot_ready:
		return
	if not infinite_ammo and current_ammo < 1:
		return

	current_ammo -= 1
	weapon_shoot(target, damage)
	emit_signal("weapon_ammo_changed", self)
	_start_shoot_timer()

func weapon_shoot(_target, _damage):
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
