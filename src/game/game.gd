class_name Game extends Node2D

@export var _levels: Array[PackedScene] = []

var _current_level_idx: int = 0
var _current_level: Node2D

func _ready() -> void:
	EventBus.level_exit_reached.connect(_on_level_exit_reached)

	_load_level()


func _on_level_exit_reached() -> void:
	print("_on_level_exit_reached intercepted")
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

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		_load_level()
