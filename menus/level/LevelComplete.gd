extends Control


func _complete_level():
	Level.set_completed(Level.get_current_level())

func _set_texts():
	var level: int = Level.get_current_level()
	var title = "Level %d cleared" % level
	$Title.text = title

	var new_points = ""
	if not Level.is_comleted(level):
		new_points = "%d Points added\nSee Characer menu" % level
	$NewPoints.text = new_points

func _ready():
	_set_texts()

func _on_character_pressed():
	SceneLoader.load_character_menu()


func _on_menu_pressed():
	SceneLoader.load_main_menu()
	_complete_level()


func _on_next_pressed():
	SceneLoader.load_scene(Level.next_scene())
	_complete_level()
