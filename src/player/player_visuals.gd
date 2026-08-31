class_name PlayerVisuals
extends Node2D

const ANIM_MOVE_RIGHT = "move_right"
const ANIM_MOVE_LEFT = "move_right"
const ANIM_JUMP = "jump"
const ANIM_IDLE = "idle"

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _sprite: Sprite2D = %Sprite

func set_animation(animation_name: String) -> void:
	if _animation_player.current_animation == animation_name:
		return

	_animation_player.play(animation_name)


func moving(dir_x: float) -> void:
	var animation = _get_move_animation(dir_x)

	set_animation(animation)

	if dir_x < 0:
		_sprite.flip_h = true
	else:
		_sprite.flip_h = false


func _get_move_animation(direction: float) -> StringName:
	if direction == 0:
		return ANIM_IDLE

	if direction < 0:
		return ANIM_MOVE_LEFT

	return ANIM_MOVE_RIGHT
