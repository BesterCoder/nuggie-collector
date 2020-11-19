extends KinematicBody2D

enum {DIR_LEFT = -1, DIR_RIGHT = 1, DIR_NONE = 0}

var speed = 50
var velocity = Vector2(0, 0)
# export makes the variable modifiable in the scene editor
export var direction = DIR_LEFT
export var detects_cliffs = true

func _ready():
	$SlimeAnimation.play("moving")

	if direction == DIR_LEFT:
		$SlimeAnimation.flip_h = true

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
		$SlimeAnimation.flip_h = not $SlimeAnimation.flip_h
		# Set the floor checker ray to left or right of the collision box
		# Depending on the enemy's direction
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction

	velocity.y += 20
	velocity.x = speed * direction
	velocity = move_and_slide(velocity, Vector2.UP)
