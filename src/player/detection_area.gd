class_name DetectionArea
extends Area2D

func edge_find_first() -> Edge:
	for area in get_overlapping_areas():
		if area is Edge:
			return area

	return null



func get_interactives() -> Array[Node2D]:
	var nodes: Array[Node2D]

	for area in get_overlapping_areas():
		if area is SkillCard:
			nodes.append(area)

		if area is Edge:
			nodes.append(area)

	for body in get_overlapping_bodies():
		if body is Ladder:
			nodes.append(body)


	return nodes
