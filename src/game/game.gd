class_name Game extends Node2D

@export var _levels: Array[PackedScene] = []

var _current_level_idx: int = 0
var _current_level: Node2D
var _is_in_main_menu: bool = true

@onready var _main_menu: CanvasLayer = %MainMenu
@onready var _pause_menu: CanvasLayer = %PauseMenu
@onready var _gameplay_overlay: CanvasLayer = %GameplayOverlay


func _ready() -> void:
	EventBus.level_exit_reached.connect(_on_level_exit_reached)
	EventBus.player_killed.connect(_on_player_killed)

func _on_new_game() -> void:
	_is_in_main_menu = false
	_load_level()

	_disable_menu(_main_menu)
	_enable_menu(_gameplay_overlay)

func _on_pause_menu_open() -> void:
	_disable_menu(_gameplay_overlay)
	_enable_menu(_pause_menu)

func _on_pause_menu_resume() -> void:
	_disable_menu(_pause_menu)
	_enable_menu(_gameplay_overlay)

func _on_pause_menu_reset_level() -> void:
	_disable_menu(_pause_menu)
	_load_level()

func _on_pause_menu_exit_to_main_menu() -> void:
	_is_in_main_menu = true

	_disable_menu(_pause_menu)
	_disable_menu(_gameplay_overlay)
	_enable_menu(_main_menu)

	_current_level.queue_free()

func _on_player_killed() -> void:
	_on_pause_menu_exit_to_main_menu()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		_on_pause_menu_reset_level()

		return

	if event.is_action_pressed("pause") and not _is_in_main_menu:
		_on_pause_menu_open()

		return

func _on_level_exit_reached() -> void:
	_update_level_idx()
	_load_level()

func _load_level() -> void:
	if _current_level != null:
		_current_level.queue_free()

	_current_level = _levels[_current_level_idx].instantiate()

	add_child(_current_level)


func _update_level_idx() -> void:
	if _current_level_idx == _levels.size() - 1:
		return

	_current_level_idx += 1


func _disable_menu(menu: CanvasLayer) -> void:
	menu.process_mode = Node.PROCESS_MODE_DISABLED
	menu.visible = false


func _enable_menu(menu: CanvasLayer) -> void:
	menu.process_mode = Node.PROCESS_MODE_ALWAYS
	menu.visible = true
