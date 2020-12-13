extends CanvasLayer

func _ready():
	# Don't ever stop this process
	pause_mode = Node.PAUSE_MODE_PROCESS

func _set_pause(timer: bool = false):
	$Root.visible = not $Root.visible
	get_tree().paused = not get_tree().paused

	if timer:
		if GameTimer.is_paused():
			GameTimer.start_level()
		else:
			GameTimer.pause_level()

func _physics_process(_delta):
	if Input.is_action_just_pressed("pause"):
		_set_pause(true)


func _on_continue_pressed():
	_set_pause(true)
	GameTimer.start_level()


func _on_menu_pressed():
	_set_pause()
	SceneLoader.load_main_menu()
