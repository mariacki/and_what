@tool
class_name Ladder extends Node2D

enum LadderDirection {
	UP,
	DOWN,
}

@onready var top_trigger: Area2D = $TopTrigger
@onready var bottom_trigger: Area2D = $BottomTrigger

@onready var repeatable: Repeatable = $Repeatable

@export var dir: LadderDirection = LadderDirection.UP:
	set(value):
		dir = value
		_update()

@export var number_of_segments: int = 1:
	set(value):
		number_of_segments = value
		_update()
	get:
		return number_of_segments

func _ready() -> void:
	assert(repeatable != null, "Repeatable is null")
	assert(top_trigger != null, "No collision shape")


	z_index = Units.LAYER_INTERACTIVES

	top_trigger.body_entered.connect(_on_top_enter)
	top_trigger.body_exited.connect(_on_top_exit)

	bottom_trigger.body_entered.connect(_on_bottom_enter)
	bottom_trigger.body_exited.connect(_on_bottom_exit)


	_update()

func _physics_process(_delta: float) -> void:
	_update_availability()

func _update_availability() -> void:
	var player = null

	player = _find_player_in_trigger(top_trigger)
	if player != null:
		player.ladder_available(bottom_trigger.global_position)

	player = _find_player_in_trigger(bottom_trigger)
	if player != null:
		player.ladder_available(top_trigger.global_position)



func _find_player_in_trigger(trigger: Area2D) -> Player:
	for body in trigger.get_overlapping_bodies():
		if body is Player:
			return body

	return null


func _on_top_enter(body: Node2D) -> void:
	print("top enered")
	if body is Player:
		body.ladder_available(bottom_trigger.global_position)

func _on_top_exit(body: Node2D) -> void:
	if body is Player:
		if body.global_position.distance_squared_to(bottom_trigger.global_position ) < Units.UNIT:
			return

		body.ladder_unavailable("top ladder unavailable")

func _on_bottom_enter(body: Node2D) -> void:
	if body is Player:
		body.ladder_available(top_trigger.global_position)

func _on_bottom_exit(body: Node2D) -> void:
	if body is Player:
		if body.global_position.distance_squared_to(top_trigger.global_position) <= 0.01:
			return

		body.ladder_unavailable("bottom trigger exit")


func _update() -> void:
	if not repeatable:
		return

	repeatable.orientation = Repeatable.Orientation.VERTICAL
	repeatable.number_of_segments = number_of_segments

	bottom_trigger.position = repeatable.last_segment_pos() + Vector2(0, Units.HALF)
