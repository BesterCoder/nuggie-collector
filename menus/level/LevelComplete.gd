extends Control


func _set_texts():
	var level: int = Level.get_current_level()
	var title = "Level %d cleared" % level
	$Title.text = title

	var new_points = "%d Points added\nSee Characer menu" % level
	$NewPoints.text = new_points

func _ready():
	_set_texts()

func _on_character_pressed():
	SceneLoader.load_character_menu()


func _on_menu_pressed():
	SceneLoader.load_main_menu()
