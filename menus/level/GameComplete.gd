extends Control


func _complete_level():
	Level.set_completed(Level.get_current_level())

func _set_texts():
	var level: int = Level.get_current_level()

	var new_points = ""
	var game_complete = ""
	var level_complete = ""
	if not Level.is_comleted(level):
		new_points = "%d Points added\nSee Characer menu" % level
		var game_time = GameTimer.get_game_time_fmt()
		game_complete = "Game cleared in\n%s" % game_time
		var level_time = GameTimer.get_level_time_fmt(level)
		level_complete = "Level cleared in\n%s" % level_time

	$GameTime.text = game_complete
	$LevelTime.text = level_complete
	$NewPoints.text = new_points

func _ready():
	GameTimer.stop_level()
	_set_texts()


func _on_character_pressed():
	SceneLoader.load_character_menu()


func _on_menu_pressed():
	SceneLoader.load_main_menu()
	_complete_level()

