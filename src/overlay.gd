extends CanvasLayer

@onready var item_list: Container = %Container

func _ready() -> void:
	EventBus.skills_updated.connect(_on_skills_updated)

func _on_skills_updated(skills: Array[SkillCard]):
	for child in item_list.get_children():
		child.queue_free()

	for skill in skills:
		var label = Label.new()
		label.text = "[%s] %s" % [skill.requires_string(), skill.provides_string()]
		label.add_theme_color_override("font_color", Color.BLACK)
		label.add_theme_font_size_override("font_size", 8)
		item_list.add_child(label)
