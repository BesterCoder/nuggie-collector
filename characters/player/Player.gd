extends KinematicBody2D

const SPEED = 180*3
const GRAVITY = 35
const JUMPFORCE = -1000

var velocity = Vector2(0, 0)
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	# Smoothly stop the character from moving with lerp
	velocity.x = lerp(velocity.x, 0, 0.2)
