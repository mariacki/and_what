@tool
class_name Repeatable extends Node2D

enum SegmentType {
	TOP,
	MIDDLE,
	BOTTOM,
}

enum Orientation {
	VERTICAL,
	HORIZONTAL,
}

var orientation: Repeatable.Orientation = Orientation.VERTICAL:
	set(value):
		orientation = value
		update()

var number_of_segments: int:
	set(value):
		number_of_segments = value
		update()
	get:
		return number_of_segments

var _first: RepeatableSegment
var _middle: RepeatableSegment
var _last: RepeatableSegment

func _ready() -> void:
	for child in get_children():
		if child is RepeatableSegment:
			match child.type:
				RepeatableSegment.Type.FIRST: _first = child
				RepeatableSegment.Type.MIDDLE: _middle = child
				RepeatableSegment.Type.BOTTOM: _last = child

	assert(_first != null, "First segment not provided")
	assert(_middle != null, "Middle segment not provided")
	assert(_last != null, "Last segment not provided")

	_middle.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	_middle.region_enabled = true


func update():
	if not is_inside_tree():
		return

	print("Repeatable updating")
	match(orientation):
		Orientation.HORIZONTAL: _update_horizontal()
		Orientation.VERTICAL: _update_vertical()

func last_segment_pos() -> Vector2:
	return _last.position

func first_segment_pos() -> Vector2:
	return _first.position

func get_width() -> float:
	return Units.UNIT + number_of_segments * Units.UNIT

func _update_horizontal() -> void:
	var width = number_of_segments * Units.UNIT

	_last.position.x = width + Units.HALF

	_middle.region_rect = Rect2(0, 0, width, Units.UNIT)
	_middle.position.x = width / 2

func _update_vertical() -> void:
	print("Update vertical")
	var height = number_of_segments * Units.UNIT

	_last.position.y = height + Units.HALF

	_middle.region_rect = Rect2(0, 0, Units.UNIT, height)
	_middle.position.y = height / 2
