extends Control

var _level_buttons = []

func _ready():
	_level_buttons = [
		$Level1,
		$Level2,
		$Level3,
		$Level4,
		$Level5,
		$Level6,
		$Level7
	]

	_show_levels()

func _show_levels():
	for btn in _level_buttons:
		btn.visible = false

	for lvl in range(Level.next_available_level()):
		_level_buttons[lvl].visible = true

func _load_level(level: int):
	Level.set_level(level)
	SceneLoader.load_scene(Level.get_current_scene())
	GameTimer.start_level()


func _on_return_pressed():
	SceneLoader.load_previous_scene()


func _on_reset_progress_pressed():
	Level.reset()
	Character.reset()
	_show_levels()
	# TODO: reset speedrun timer


func _on_level1_pressed():
	_load_level(1)


func _on_level2_pressed():
	_load_level(2)


func _on_level3_pressed():
	_load_level(3)


func _on_level4_pressed():
	_load_level(4)


func _on_level5_pressed():
	_load_level(5)


func _on_level6_pressed():
	_load_level(6)


func _on_level7_pressed():
	_load_level(7)
