extends Control


func _complete_level():
	Level.set_completed(Level.get_current_level())

func _set_texts():
	var level: int = Level.get_current_level()
	var title = "Level %d cleared" % level
	$Title.text = title

	var new_points = ""
	var comlete_time = ""
	if not Level.is_comleted(level):
		new_points = "%d Points added\nSee Characer menu" % level
		var level_time = GameTimer.get_level_time_fmt(level)
		comlete_time = "Level cleared in\n%s" % level_time

	$Time.text = comlete_time
	$NewPoints.text = new_points

func _ready():
	GameTimer.stop_level()
	_set_texts()

func _on_character_pressed():
	SceneLoader.load_character_menu()


func _on_menu_pressed():
	SceneLoader.load_main_menu()
	_complete_level()


func _on_next_pressed():
	_complete_level()
	SceneLoader.load_scene(Level.next_scene())
	GameTimer.start_level()


func _on_controls_pressed():
	SceneLoader.load_control_menu()
