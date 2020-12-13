extends Control


func _on_play_pressed():
	SceneLoader.load_scene(Level.get_current_scene())
	GameTimer.start_level()


func _on_character_pressed():
	SceneLoader.load_character_menu()


func _on_levels_pressed():
	SceneLoader.load_level_menu()
