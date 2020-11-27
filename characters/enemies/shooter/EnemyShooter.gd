extends KinematicBody2D

enum {DIR_LEFT = -1, DIR_RIGHT = 1, DIR_NONE = 0}

var speed = 50
var current_hp = -1
var velocity = Vector2(0, 0)
var shoot_target = null

# export makes the variable modifiable in the scene editor
export var direction = DIR_LEFT
export var detects_cliffs = true
export var hp_amount : int = 2

func hurt():
	current_hp -= 1
	if current_hp == 0:
		$HealthBar.get_node("ColorRect").rect_size.x = 0
		queue_free()
		return

	var current_size = $HealthBar.get_node("ColorRect").rect_size.x
	var new_size = float(current_size) * (float(current_hp) / hp_amount)
	$HealthBar.get_node("ColorRect").rect_size.x = new_size

func _weapon_pos():
	if shoot_target == null:
		return

	var direction = 0
	if shoot_target.global_position.x > self.global_position.x:
		direction = 1
	else:
		direction = -1

	if direction < 0:
		$Pistol.flip_v = true
	else:
		$Pistol.flip_v = false

	# Set weapon position
	var offset = 100 * direction
	$Pistol.position.x = $Body.texture.get_width() * direction - offset

func _ready():
	current_hp = hp_amount
	add_to_group("enemies")

	# Set the floor checker ray to left or right of the collision box
	# depending on the enemy's direction
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_checker.enabled = detects_cliffs


func _physics_process(_delta):
	# Flip the character if it hits a wall or while it hits the end of a cliff
	# while being on the floor (ground)
	# TODO: clener if
	if is_on_wall() or (detects_cliffs and not $floor_checker.is_colliding() and is_on_floor()):
		# Flip the direction
		direction = direction * -1
		# Set the floor checker ray to left or right of the collision box
		# Depending on the enemy's direction
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction

	velocity.y += 20
	velocity.x = speed * direction
	velocity = move_and_slide(velocity, Vector2.UP)

	if shoot_target != null:
		_weapon_pos()
		$Pistol.look_at(shoot_target.global_position)
		$Pistol.shoot(shoot_target)

func _on_player_body_entered(body):
	$Pistol.look_at(body.global_position)
	shoot_target = body
	speed = 0


func _on_player_body_exited(_body):
	shoot_target = null
	speed = 50
	if $Pistol.flip_v:
		$Pistol.rotation = 180 - 45
	else:
		$Pistol.rotation = 0.0
