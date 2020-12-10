extends KinematicBody2D

class_name EnemyBase

enum {DIR_LEFT = -1, DIR_RIGHT = 1, DIR_NONE = 0}
enum {DROP_NONE = 0, DROP_HEALTH = 1, DROP_RIFLE_AMMO = 2, DROP_SHOTGUN_AMMO = 3}

var speed = 50
var current_hp = -1
var velocity = Vector2(0, 0)
var number_dir = -1
var moved_amount: float = 0
var explode_bullet = null
var drop_item = null

# export makes the variable modifiable in the scene editor
export var direction = DIR_LEFT
export var detects_cliffs = true
export var hp_amount : int = 2
export var damage_amount: int = 20
export var movement_range: int = -1
export var moving: bool = true
export var damage_number: PackedScene
export var explode: bool = false
export var drop_type: int = DROP_NONE


func _explode():
	var _angle = 15
	var _vector = Vector2(1, 0)
	for _nouse in range(12):
		var new_bullet = explode_bullet.instance()
		new_bullet.initialize(global_position, _vector.rotated(deg2rad(_angle)), int(damage_amount / 2))
		get_tree().current_scene.call_deferred("add_child", new_bullet)
		_angle += 30

func hurt():
	current_hp -= 1

	var number = damage_number.instance()
	var startpos = global_position
	startpos.y -= 20
	number_dir *= -1
	number.initialize(startpos, 1, number_dir)
	get_tree().get_root().call_deferred("add_child", number)

	if current_hp == 0:
		if explode:
			_explode()
		if drop_item != null:
			var item = drop_item.instance()
			item.initialize(global_position, drop_type)
			get_tree().current_scene.call_deferred("add_child", item)

		$HealthBar.get_node("ColorRect").rect_size.x = 0
		queue_free()
		return

	var current_size = $HealthBar.get_node("ColorRect").rect_size.x
	var new_size = float(current_size) * (float(current_hp) / hp_amount)
	$HealthBar.get_node("ColorRect").rect_size.x = new_size


func _ready():
	current_hp = hp_amount
	add_to_group("enemies")

	if explode:
		explode_bullet = load("res://characters/weapons/bullet/EnemyBullet.tscn")

	match drop_type:
		DROP_NONE:
			drop_item = null
		DROP_HEALTH:
			drop_item = load("res://items/health/Health.tscn")
		DROP_RIFLE_AMMO, DROP_SHOTGUN_AMMO:
			drop_item = load("res://items/ammo/Ammo.tscn")
		_:
			push_error("EnemyBase.gd: Invalid drop_type: %d" % drop_type)

	# Set the floor checker ray to left or right of the collision box
	# depending on the enemy's direction
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_checker.enabled = detects_cliffs

	_child_ready()


func _child_ready():
	var msg = "EnemyBase.gd: _child_ready is not overridden"
	print(msg)
	push_error(msg)


func _physics_process(delta):
	# Flip the character if it hits a wall or while it hits the end of a cliff
	# while being on the floor (ground)
	# TODO: clener if
	if is_on_wall() or (detects_cliffs and not $floor_checker.is_colliding() and is_on_floor()) or (movement_range > 0 and abs(moved_amount) >= movement_range):
		# Flip the direction
		direction = direction * -1
		# Set the floor checker ray to left or right of the collision box
		# Depending on the enemy's direction
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
		_child_change_direction()

	var x_move = speed * direction
	if not moving:
		x_move = 0

	moved_amount += x_move * delta
	velocity.y += 20
	velocity.x = x_move
	velocity = move_and_slide(velocity, Vector2.UP)
	_child_physics_process(delta)


func _child_change_direction():
	var msg = "EnemyBase.gd: _child_change_direction is not overridden"
	print(msg)
	push_error(msg)


func _child_physics_process(_delta):
	var msg = "EnemyBase.gd: _child_physics_process is not overridden"
	print(msg)
	push_error(msg)
