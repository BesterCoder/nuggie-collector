extends KinematicBody2D

const SPEED = 180*3
const GRAVITY = 35
const JUMPFORCE = -1000
# How much does the player body tilt/rotate when moving
const TILT_DEGREE = 5.0

enum move_dir {MOVE_LEFT, MOVE_RIGHT, MOVE_NONE}

var velocity = Vector2(0, 0)

func _tilt_player(dir):
	match dir:
		move_dir.MOVE_LEFT:
			$Body.rotation_degrees = -TILT_DEGREE
		move_dir.MOVE_RIGHT:
			$Body.rotation_degrees = TILT_DEGREE
		move_dir.MOVE_NONE:
			$Body.rotation_degrees = 0


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("move_right"):
		_tilt_player(move_dir.MOVE_RIGHT)
		velocity.x = SPEED
	elif Input.is_action_pressed("move_left"):
		_tilt_player(move_dir.MOVE_LEFT)
		velocity.x = -SPEED
	else:
		_tilt_player(move_dir.MOVE_NONE)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		# TODO: Leave the GroundHalo on ground when jumping
		velocity.y = JUMPFORCE

	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	# Smoothly stop the character from moving with lerp
	velocity.x = lerp(velocity.x, 0, 0.2)
