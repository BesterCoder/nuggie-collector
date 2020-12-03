extends CanvasLayer

var nuggie_count = 0
var nuggies_collected = 0
var player = null
var hud_weapons = []
var hp_bar_width = 0

var level_portal = load("res://items/portal/Portal.tscn")

# Print and push a error message end exit the game
func _hud_error_exit(message: String):
	var msg = "PlayerHUD.gd: %s" % message
	print(msg)
	push_error(msg)
	get_tree().quit()

func _ready():
	hp_bar_width = $HealthBar.rect_size.x

	var nuggies = get_tree().get_root().find_node("Nuggies", true, false).get_children()
	# Nuggies are required in each level
	if nuggies == null:
		_hud_error_exit("No Nuggies found in the Scene")
	for nuggie in nuggies:
		nuggie.connect("nuggie_collected", self, "_on_nuggie_collected")
	nuggie_count = len(nuggies)
	_update_nuggie_text()

	player = get_tree().get_root().find_node("Player", true, false)
	# Nuggies are required in each level
	if player == null:
		_hud_error_exit("No Player found in the Scene")
	player.connect("weapon_chagned", self, "_on_weapon_changed")
	player.connect("health_chagned", self, "_on_health_changed")
	_on_health_changed()

	# Weapons need to be in the same order as in Player.gd
	hud_weapons = [$Pistol, $Rifle, $Shotgun]
	for wp in hud_weapons:
		player.get_node(wp.name).connect("weapon_ammo_changed", self, "_on_weapon_ammo_changed")
	_update_ammo_text(player.current_weapon)

func _update_nuggie_text():
	var text = ": %d/%d" % [nuggies_collected, nuggie_count]
	$NuggieCollected.text = text

func _update_ammo_text(weapon):
	if weapon.infinite_ammo:
		# TODO: infinity image?
		$Ammo/Label.text = "Inf"
	else:
		$Ammo/Label.text = "%d/%d" % [weapon.current_ammo, weapon.max_ammo]

func _on_nuggie_collected(nuggie_position):
	nuggies_collected += 1
	_update_nuggie_text()
	if nuggies_collected == nuggie_count:
		var portal = level_portal.instance()
		portal.global_position = nuggie_position
		get_tree().get_root().call_deferred("add_child", portal)

func _on_health_changed():
	var new_size = float(hp_bar_width) * (float(player.health) / player.max_health)
	$HealthBar.rect_size.x = new_size
	$HealthBar/HpAmount.text = "%d/%d" % [player.health, player.max_health]

func _on_weapon_changed():
	for idx in range(len(player.weapons)):
		if hud_weapons[idx].name == player.current_weapon.name:
			_update_ammo_text(player.current_weapon)
			hud_weapons[idx].get_node("TextureRect").visible = true
		else:
			hud_weapons[idx].get_node("TextureRect").visible = false

func _on_weapon_ammo_changed(weapon):
	_update_ammo_text(weapon)
