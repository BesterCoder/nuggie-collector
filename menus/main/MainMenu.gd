extends Control


func _on_play_pressed():
	SceneLoader.load_scene("res://levels/level_001.tscn")


func _on_character_pressed():
	SceneLoader.load_scene("res://menus/character/CharacterMenu.tscn")
