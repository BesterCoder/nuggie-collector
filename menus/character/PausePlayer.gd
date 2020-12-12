extends CanvasLayer

func _ready():
	# Don't ever stop this process
	pause_mode = Node.PAUSE_MODE_PROCESS

func _set_pause():
	$Root.visible = not $Root.visible
	get_tree().paused = not get_tree().paused

func _physics_process(_delta):
	if Input.is_action_just_pressed("pause"):
		_set_pause()

func _on_continue_pressed():
	_set_pause()

func _on_menu_pressed():
	_set_pause()
	SceneLoader.load_main_menu()
