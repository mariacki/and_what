@tool
class_name Transport extends Node2D

@onready var top_trigger: TransportPoint = $TopTrigger
@onready var bottom_trigger: TransportPoint = $BottomTrigger
@onready var repeatable: Repeatable = $Repeatable

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
	_update()

func _update() -> void:
	if not repeatable:
		return

	repeatable.orientation = Repeatable.Orientation.VERTICAL
	repeatable.number_of_segments = number_of_segments

	bottom_trigger.position = repeatable.last_segment_pos() + Vector2(0, Units.HALF)

func get_destination(player: Player) -> Vector2:
	if player in top_trigger.get_overlapping_bodies():
		return bottom_trigger.global_position

	return top_trigger.global_position
