extends Node


var __level_list = [
	"res://levels/level_001.tscn"
]

var __level_count = len(__level_list)
var __current_level: int = 1

func get_current_level() -> int:
	return __current_level


func get_current_scene() -> String:
	return __level_list[__current_level - 1]


# Increment level and return the level int
func next_level() -> int:
	__current_level += 1
	return __current_level


func next_scene() -> String:
	__current_level += 1
	return __level_list[__current_level - 1]


func set_level(level: int) -> void:
	__current_level = level
