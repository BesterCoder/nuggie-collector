extends KinematicBody2D

const SPEED = 180*3
const GRAVITY = 35
const JUMPFORCE = -1000
# How much does the player body tilt/rotate when moving
const TILT_DEGREE = 5.0

enum move_dir {MOVE_LEFT = -1, MOVE_RIGHT = 1, MOVE_NONE = 0}

var current_direction = move_dir.MOVE_RIGHT
var current_weapon = null
var velocity = Vector2(0, 0)
var player_halo = null

# Rotate and and the weapon location
# based on mouse location and move direction
func _weapon_pos():
	# Rotate weapon
	var mouse_pos = get_global_mouse_position();
	var direction = sign(mouse_pos.x - current_weapon.global_position.x)
	if direction < 0:
		current_weapon.flip_v = true
	else:
		current_weapon.flip_v = false

	current_weapon.look_at(mouse_pos)

	# Set weapon position
	var offset = 100 * current_direction
	current_weapon.position.x = $Body.texture.get_width() * current_direction - offset

func _tilt_player(dir):
	match dir:
		move_dir.MOVE_LEFT:
			$Body.rotation_degrees = -TILT_DEGREE
		move_dir.MOVE_RIGHT:
			$Body.rotation_degrees = TILT_DEGREE
		move_dir.MOVE_NONE:
			$Body.rotation_degrees = 0

	$halo_floor.position.x = $Body.texture.get_width() * dir

func _halo_location():
	if is_on_floor():
		player_halo.position = self.position
		# +39 seems to look the best
		player_halo.position.y += 39
		return

	if not $halo_floor.is_colliding():
		return

	var col_point =  $halo_floor.get_collision_point()
	player_halo.position = col_point
	# -25 seems to look the best in the game
	player_halo.position.y -= 25
	player_halo.position.x = self.position.x

func _shoot():
	current_weapon.shoot()

func _ready():
	player_halo = get_tree().get_root().find_node("PlayerGroundHalo", true, false)
	current_weapon = $Pistol

func _physics_process(_delta):
	_weapon_pos()
	_halo_location()

	if Input.is_action_pressed("move_right"):
		current_direction = move_dir.MOVE_RIGHT
		_tilt_player(move_dir.MOVE_RIGHT)
		velocity.x = SPEED
	elif Input.is_action_pressed("move_left"):
		current_direction = move_dir.MOVE_LEFT
		_tilt_player(move_dir.MOVE_LEFT)
		velocity.x = -SPEED
	else:
		_tilt_player(move_dir.MOVE_NONE)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMPFORCE

	if Input.is_action_just_pressed("player_shoot"):
		_shoot()

	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	# Smoothly stop the character from moving with lerp
	velocity.x = lerp(velocity.x, 0, 0.2)
