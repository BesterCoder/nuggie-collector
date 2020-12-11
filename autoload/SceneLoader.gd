extends Node

# From
# https://docs.godotengine.org/en/stable/getting_started/step_by_step/singletons_autoload.html

var current_scene = null
var current_scene_path: String = ""
var previous_scene_path: String = ""

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	current_scene_path = current_scene.filename

func load_previous_scene():
	load_scene(previous_scene_path)

func load_main_menu():
	load_scene("res://menus/main/MainMenu.tscn")

func load_character_menu():
	load_scene("res://menus/character/CharacterMenu.tscn")

func load_level_complete():
	load_scene("res://menus/level/LevelComplete.tscn")

func load_scene(scene_path: String):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	previous_scene_path = current_scene_path
	current_scene_path = scene_path
	call_deferred("_deferred_load_scene", scene_path)


func _deferred_load_scene(scene_path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(scene_path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
