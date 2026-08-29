@tool
extends StaticBody2D

@onready var platform: CollisionShape2D = $Floor
@onready var repeatable: Repeatable = $Repeatable

@export var number_of_segments: int = 1:
	set(value):
		number_of_segments = value
		_update()
	get:
		return number_of_segments

func _ready() -> void:
	platform.shape = platform.shape.duplicate()
	_update()

func _update() -> void:
	if not repeatable:
		return


	repeatable.orientation = Repeatable.Orientation.HORIZONTAL
	repeatable.number_of_segments = number_of_segments

	platform.shape.size.x = repeatable.get_width() + Units.HALF
	platform.position.x = platform.shape.size.x / 2 - Units.HALF
