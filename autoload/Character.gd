extends Node


var __hp: int = 100
var __damage: int = 1
const __HEALTH_STEP: int = 10
const __DAMAGE_STEP: int = 1
var __health_points: int = 0
var __damage_points: int = 0
var __points_left: int = 0


func get_hp() -> int:
	return __hp + __HEALTH_STEP * __health_points


func get_damage() -> int:
	return __damage + __DAMAGE_STEP * __damage_points


func get_health_points() -> int:
	return __health_points


func get_damage_points() -> int:
	return __damage_points


func get_points_left() -> int:
	return __points_left


func add_points(amount: int = 1) -> void:
	if amount < 0 && __points_left <= 0:
		return
	__points_left += amount


func add_damage_points(amount: int = 1) -> void:
	if amount < 0 && __damage_points <= 0:
		return
	if amount > 0 && __points_left <= 0:
		return

	__points_left -= amount
	__damage_points += amount


func add_health_points(amount: int = 1) -> void:
	if amount < 0 && __health_points <= 0:
		return
	if amount > 0 && __points_left <= 0:
		return

	__points_left -= amount
	__health_points += amount
