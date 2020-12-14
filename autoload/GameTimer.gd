extends Node

# Keep track of a single level
var __level_clock: float = 0
var __level_paused: bool = true
var __level_times = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

func _ready():
	# Don't ever stop this process
	pause_mode = Node.PAUSE_MODE_PROCESS

func _physics_process(delta):
	if not __level_paused:
		__level_clock += delta

func _format_time(time: float) -> String:
	var seconds = int(time)
	var minutes = int(seconds / 60)
	seconds %= 60

	return "%02dm:%02ds" % [minutes, seconds]

func reset_times() -> void:
	for idx in range(len(__level_times)):
		__level_times[idx] = 0

func is_paused() -> bool:
	return __level_paused

func start_level() -> void:
	__level_paused = false

func pause_level() -> void:
	__level_paused = true

func reset_level() -> void:
	__level_clock = 0

func stop_level() -> void:
	var level_idx = Level.get_current_level() - 1
	if __level_times[level_idx] == 0:
		__level_times[level_idx] = __level_clock

	__level_clock = 0
	pause_level()

func get_level_time(level: int) -> float:
	return __level_times[level - 1]

func get_level_time_fmt(level: int) -> String:
	return _format_time(get_level_time(level))

func get_game_time() -> float:
	var game_time: float = 0
	for time in __level_times:
		game_time += time

	return game_time

func get_game_time_fmt() -> String:
	return _format_time(get_game_time())
