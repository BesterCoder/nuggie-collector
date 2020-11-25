extends Area2D


enum {
	TYPE_RIFLE = 1,
	TYPE_SHOTGUN = 2
}

# 1: rifle, 2: shotgun
export var ammo_type = TYPE_SHOTGUN

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
			push_error("Invalid ammo type: " + ammo_type)



func _on_body_entered(body):
	if body.name != "Player":
		return

	var success = body.add_ammo(self)
	if success:
		queue_free()

