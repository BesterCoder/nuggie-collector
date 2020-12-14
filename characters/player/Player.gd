extends KinematicBody2D

signal weapon_chagned
signal health_chagned

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
var weapons = []
var health = 100
var max_health = 100
var hurting = false
var found_portal = null

# Dealing negative damage heals the player
# if enemy_posx is not NAN player is knocked back
# to a direction based on enemy_position
func deal_damage(damage: int, enemy_posx: int = NAN) -> bool:
	# Signal that player is full health when trying to heal
	if damage < 0 && health == max_health:
		return false

	health -= damage
	if health <= 0:
		SceneLoader.load_dead_player()
	elif health > max_health:
		health = max_health
	emit_signal("health_chagned")

	# Deal with knockback after the damage is dealt
	# NAN is not equal to it self
	if String(enemy_posx) == "nan":
		return true

	set_modulate(Color(1, 0.3, 0.3, 0.4))
	velocity.y = JUMPFORCE * 0.5

	if position.x < enemy_posx:
		velocity.x = -1500
	elif position.x > enemy_posx:
		velocity.x = 1500

	hurting = true
	$HurtTimer.start()
	return true

# Add a ammo object
func add_ammo(ammo):
	# See types from Ammo.gd
	match ammo.ammo_type:
		1:
			var equipped = current_weapon.name == "Rifle"
			return $Rifle.add_ammo(ammo.ammo_amount, equipped)
		2:
			var equipped = current_weapon.name == "Shotgun"
			return $Shotgun.add_ammo(ammo.ammo_amount, equipped)

	# Ammo not collected
	return false

# Rotate and and the weapon location
# based on mouse location and move direction
func _weapon_pos():
	# Rotate weapon
	var mouse_pos = get_global_mouse_position();
	# global_position.x is in the middle of the character
	var halfsize = int($Body.texture.get_size().x * scale.x / 2)
	var player_left = global_position.x - halfsize
	var player_right = global_position.x + halfsize

	var direction = 0
	if mouse_pos.x < player_left:
		direction = -1
	elif mouse_pos.x > player_right:
		direction = 1
	else:
		direction = current_direction

	if direction < 0:
		current_weapon.flip_v = true
	else:
		current_weapon.flip_v = false

	current_weapon.look_at(mouse_pos)

	# Set weapon position
	var offset = 100 * direction
	current_weapon.position.x = $Body.texture.get_width() * direction - offset

func _tilt_player(dir):
	match dir:
		move_dir.MOVE_LEFT:
			$Body.rotation_degrees = -TILT_DEGREE
		move_dir.MOVE_RIGHT:
			$Body.rotation_degrees = TILT_DEGREE
		move_dir.MOVE_NONE:
			$Body.rotation_degrees = 0

	$halo_floor.position.x = $Body.texture.get_width() * self.scale.x * dir

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
	current_weapon.shoot(null, Character.get_damage())

func _change_weapon(idx: int):
	if current_weapon.name == weapons[idx].name:
		return

	current_weapon = weapons[idx]
	for wp in weapons:
		if wp.name == current_weapon.name:
			wp.visible = true
		else:
			wp.visible = false


	emit_signal("weapon_chagned")

func _ready():
	player_halo = get_tree().get_root().find_node("PlayerGroundHalo", true, false)
	weapons = [$Pistol, $Rifle, $Shotgun]
	current_weapon = weapons[0]
	max_health = Character.get_hp()
	health = max_health

	# Be absolutely sure that there are no porals when player is loaded
	var tmp_portal = get_tree().get_root().find_node("Portal", true, false)
	if tmp_portal != null:
		tmp_portal.queue_free()

	$BgLoop.play(0.0)

func _move_player():
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	# Smoothly stop the character from moving with lerp
	velocity.x = lerp(velocity.x, 0, 0.2)

func _physics_process(_delta):
	_weapon_pos()
	_halo_location()

	if hurting:
		_move_player()
		return

	if $Interact.visible and Input.is_action_pressed("interact"):
		Level.level_complete()
		if Level.in_last_level():
			SceneLoader.load_game_complete()
		else:
			SceneLoader.load_level_complete()
		found_portal.queue_free()

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

	if current_weapon.name == "Rifle":
		if Input.is_action_pressed("player_shoot"):
			_shoot()
	elif Input.is_action_just_pressed("player_shoot"):
		_shoot()

	if Input.is_action_just_pressed("select_pistol"):
		_change_weapon(0)
	elif Input.is_action_just_pressed("select_rifle"):
		_change_weapon(1)
	elif Input.is_action_just_pressed("select_shotgun"):
		_change_weapon(2)

	_move_player()

func _on_hurt_timer_timeout():
	# Restore the color back to normal
	set_modulate(Color(1, 1, 1, 1))
	hurting = false

func enter_portal_area(portal):
	found_portal = portal
	$Interact.visible = true

func exit_portal_area():
	$Interact.visible = false
