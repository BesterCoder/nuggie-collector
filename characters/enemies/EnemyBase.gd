extends KinematicBody2D

class_name EnemyBase

enum {DIR_LEFT = -1, DIR_RIGHT = 1, DIR_NONE = 0}

var speed = 50
var current_hp = -1
var velocity = Vector2(0, 0)
var number_dir = -1

# export makes the variable modifiable in the scene editor
export var direction = DIR_LEFT
export var detects_cliffs = true
export var hp_amount : int = 2
export var damage_number: PackedScene

func hurt():
	current_hp -= 1

	var number = damage_number.instance()
	var startpos = global_position
	startpos.y -= 20
	number_dir *= -1
	number.initialize(startpos, 1, number_dir)
	get_tree().get_root().call_deferred("add_child", number)

	if current_hp == 0:
		$HealthBar.get_node("ColorRect").rect_size.x = 0
		queue_free()
		return

	var current_size = $HealthBar.get_node("ColorRect").rect_size.x
	var new_size = float(current_size) * (float(current_hp) / hp_amount)
	$HealthBar.get_node("ColorRect").rect_size.x = new_size


func _ready():
	current_hp = hp_amount
	add_to_group("enemies")

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
	if is_on_wall() or (detects_cliffs and not $floor_checker.is_colliding() and is_on_floor()):
		# Flip the direction
		direction = direction * -1
		# Set the floor checker ray to left or right of the collision box
		# Depending on the enemy's direction
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
		_child_change_direction()

	velocity.y += 20
	velocity.x = speed * direction
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
