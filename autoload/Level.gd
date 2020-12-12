extends Node


# [scene_path, is_completed]
var __level_list = [
	["res://levels/level_001.tscn", false]
]

var __level_count = len(__level_list)
var __current_level: int = 1

func get_current_level() -> int:
	return __current_level


func get_current_scene() -> String:
	return __level_list[__current_level - 1][0]


# Increment level and return the level int
func next_level() -> int:
	__current_level += 1
	return __current_level


func next_scene() -> String:
	__current_level += 1
	return __level_list[__current_level - 1][0]


func set_level(level: int) -> void:
	__current_level = level


func set_completed(level: int):
	__level_list[level - 1][1] = true


func is_comleted(level: int):
	return __level_list[level - 1][1]


func level_complete():
	if __level_list[__current_level - 1][1]:
		return

	Character.add_points(__current_level)
