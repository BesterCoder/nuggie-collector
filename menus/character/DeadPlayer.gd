extends Control


func _on_reset_pressed():
	SceneLoader.load_scene(Level.get_current_scene())

func _on_character_pressed():
	SceneLoader.load_character_menu()

func _on_menu_pressed():
	SceneLoader.load_main_menu()
