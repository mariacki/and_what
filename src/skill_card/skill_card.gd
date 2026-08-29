@tool
class_name SkillCard extends Area2D

@onready var req_label: Label = %ReqLabel
@onready var provides_label: Label = %SkillLabel

@export var requires: String = "":
	set(value):
		requires = value
		_update_requires_label()

@export var provides: String = "":
	set(value):
		provides = value
		_update_provides_label()



func _ready() -> void:
	assert(req_label != null, "null requirement label")
	assert(provides_label != null, "null provides label")

	req_label.text = requires
	provides_label.text = provides

	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)


func _body_entered(body: Node2D) -> void:
	if body is Player:
		print("player entered")
		body.skill_card_available(self)


func _body_exited(body: Node2D) -> void:
	if body is Player:
		print("player exited")
		body.skill_card_unavailable()


func _update_requires_label() -> void:
	if not req_label:
		return

	req_label.text = requires

func _update_provides_label() -> void:
	if not provides_label:
		return

	print("updating label")
	provides_label.text = provides
