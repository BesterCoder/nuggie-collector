extends CanvasLayer

var nuggie_count = 0
var nuggies_collected = 0
var player = null
var hud_weapons = []

# Print and push a error message end exit the game
func _hud_error_exit(message: String):
	var msg = "PlayerHUD.gd: %s" % message
	print(msg)
	push_error(msg)
	get_tree().quit()

func _ready():
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

	# Weapons need to be in the same order as in Player.gd
	hud_weapons = [$Pistol, $Rifle, $Shotgun]

func _update_nuggie_text():
	var text = ": %d/%d" % [nuggies_collected, nuggie_count]
	$NuggieCollected.text = text

func _on_nuggie_collected():
	nuggies_collected += 1
	_update_nuggie_text()

func _on_weapon_changed():
	for idx in range(len(player.weapons)):
		if hud_weapons[idx].name == player.current_weapon.name:
			hud_weapons[idx].get_node("TextureRect").visible = true
		else:
			hud_weapons[idx].get_node("TextureRect").visible = false
