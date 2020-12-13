extends BaseItem


enum {
	TYPE_RIFLE = 1,
	TYPE_SHOTGUN = 2
}

# 1: rifle, 2: shotgun
export(int, "None", "Rifle", "Shotgun") var ammo_type: int = TYPE_SHOTGUN

var ammo_amount = 0

func _ready():
	$RifleSprite.visible = false
	$ShotgunSprite.visible = false
	match ammo_type:
		TYPE_RIFLE:
			$RifleSprite.visible = true
			ammo_amount = 10
		TYPE_SHOTGUN:
			$ShotgunSprite.visible = true
			ammo_amount = 5
		_:
			push_error("Invalid ammo type: %d" % ammo_type)

func set_ammo_as_rifle():
	ammo_type = TYPE_RIFLE
	$RifleSprite.visible = true
	$ShotgunSprite.visible = false
	ammo_amount = 5


func _on_body_entered(body):
	if body.name != "Player":
		yspeed = 0
		return

	var success = body.add_ammo(self)
	if success:
		queue_free()

