class_name PlayerBaseState
extends State

func enter(context: Object) -> void:
	assert(context is Player, "Non Player context in PlayerBaseState::enter")
	_enter(context as Player)

func _enter(_player: Player) -> void:
	pass

func exit(context: Object) -> void:
	assert(context is Player, "Non Player context in PlayerBaseState::exit")
	_exit(context as Player)

func _exit(_player: Player) -> void:
	pass

func physics_process(_player: Player, _delta: float) -> void:
	pass

func ladder_available(_player: Player, _ladder_pos: Vector2) -> void:
	pass

func ladder_unavailable(_player: Player) -> void:
	pass
