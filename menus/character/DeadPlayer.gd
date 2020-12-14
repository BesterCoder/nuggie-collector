extends Control

func _ready():
	GameTimer.pause_level()

func _on_reset_pressed():
	SceneLoader.load_scene(Level.get_current_scene())
	GameTimer.reset_level()
	GameTimer.start_level()

func _on_character_pressed():
	SceneLoader.load_character_menu()

func _on_menu_pressed():
	SceneLoader.load_main_menu()


func _on_controls_pressed():
	SceneLoader.load_control_menu()
