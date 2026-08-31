class_name DetectionArea
extends Area2D

func edge_find_first() -> Edge:
	for area in get_overlapping_areas():
		if area is Edge:
			return area

	return null
