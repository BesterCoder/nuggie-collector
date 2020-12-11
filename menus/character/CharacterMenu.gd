extends Control


func _ready():
	_set_values()


func _set_values():
	$Info/HpPoints.text = String(Character.get_hp())
	$Info/DamagePoints.text = String(Character.get_damage())
	$PointsLeft/Points.text = String(Character.get_points_left())
	$HealthPoints/Points.text = String(Character.get_health_points())
	$DamagePoints/Points.text = String(Character.get_damage_points())



func _on_health_plus_pressed():
	Character.add_health_points(1)
	_set_values()

func _on_health_minus_pressed():
	Character.add_health_points(-1)
	_set_values()

func _on_damage_plus_pressed():
	Character.add_damage_points(1)
	_set_values()

func _on_damage_minus_pressed():
	Character.add_damage_points(-1)
	_set_values()


func _on_back_pressed():
	SceneLoader.load_previous_scene()
