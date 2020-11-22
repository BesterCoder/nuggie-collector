extends CanvasLayer

var nuggie_count = 0
var nuggies_collected = 0

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

func _update_nuggie_text():
	var text = ": %d/%d" % [nuggies_collected, nuggie_count]
	$NuggieCollected.text = text

func _on_nuggie_collected():
	nuggies_collected += 1
	_update_nuggie_text()
