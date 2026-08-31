@tool
class_name SkillCard extends Area2D

enum Skill {
	NOTHING,
	LADDER,
	ROPE,
	JUMP,
	PUSH,
}

@onready var requires_label: Label = %ReqLabel
@onready var provides_label: Label = %SkillLabel

@export var requires: Skill:
	set(value):
		requires = value
		_update_requires_label()

@export var provides: Skill:
	set(value):
		provides = value
		_update_provides_label()


func _ready() -> void:
	assert(requires_label != null, "null requirement label")
	assert(provides_label != null, "null provides label")

	requires_label.text = get_label_text(requires)
	provides_label.text = get_label_text(provides)


func _update_requires_label() -> void:
	if not requires_label:
		return

	requires_label.text = get_label_text(requires)


func _update_provides_label() -> void:
	if not provides_label:
		return

	print("updating label")
	provides_label.text = get_label_text(provides)


func requires_string() -> String:
	return get_label_text(requires)


func provides_string() -> String:
	return get_label_text(provides)


func get_label_text(type: Skill) -> String:
	match type:
		Skill.LADDER: return "Ladder"
		Skill.ROPE: return "Rope"
		Skill.JUMP: return "Jump"
		Skill.PUSH: return "Push"

	return ""
