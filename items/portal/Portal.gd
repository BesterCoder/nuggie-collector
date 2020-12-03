extends Area2D

const GROW_SPEED = 75

var scaley = 1.0
var target_height = 0
# Position of the floor
var collision_point = Vector2(0, 0)

func _ready():
	$floor_finder.enabled = true
	scaley = scale.y
	target_height = $PortalImage.texture.get_height()
	$PortalImage.region_enabled = true


func _find_floor() -> bool:
	# floor has been found if $floor_finder is no longer enabled
	if not $floor_finder.enabled:
		return true

	if not $floor_finder.is_colliding():
		return false # We should probably report an error, maybe?

	global_position = $floor_finder.get_collision_point()
	global_position.y -= 20
	$floor_finder.enabled = false
	return true

func _physics_process(delta):
	if not _find_floor():
		return

	if $PortalImage.region_rect.size.y == target_height:
		return

	if $PortalImage.region_rect.size.y < target_height:
		var speed = GROW_SPEED * delta
		$PortalImage.region_rect.size.y += speed
		position.y -= speed
	else:
		$PortalImage.region_rect.size.y = target_height
