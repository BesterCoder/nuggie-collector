extends Control


func _ready():
	# TOOD: show only the completed levels
	pass

func _load_level(level: int):
	Level.set_level(level)
	SceneLoader.load_scene(Level.get_current_scene())
	GameTimer.start_level()


func _on_return_pressed():
	SceneLoader.load_previous_scene()


func _on_reset_progress_pressed():
	Level.reset()
	Character.reset()
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


func _on_level8_pressed():
	_load_level(8)


func _on_level9_pressed():
	_load_level(9)
