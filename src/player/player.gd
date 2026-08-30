class_name Player extends CharacterBody2D

signal skills_updated(skills: Array[SkillCard])


const SPEED = 200.0
const JUMP_VELOCITY = -400.0



@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D
@export var arrow: Node2D

@export var jump_length: float = 100

var state_machine: StateMachine = StateMachine.new()
var skills: Array[SkillCard] = []


var move_dest: Vector2 = Vector2.ZERO
var moving_animation: String = "idle"
var can_climb: bool = false

var skill_card_pickup: SkillCard = null

@onready var detection_area: DetectionArea = %DetectionArea

func _ready() -> void:
	z_index = Units.LAYER_PLAYER
	animation_player.play("move")

	state_machine.register_state(PlayerWalking, PlayerWalking.new())
	state_machine.register_state(PlayerClimbing, PlayerClimbing.new())
	state_machine.register_state(PlayerFalling, PlayerFalling.new())

	state_machine.switch_state(PlayerWalking, self)

func apply_vertical_velocity() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	_update_animations(direction)

func apply_gravity() -> void:
	if not is_on_floor():
		velocity.y = 200

func _current_state() -> PlayerBaseState:
	return state_machine.current as PlayerBaseState

func _physics_process(delta: float) -> void:
	_current_state().physics_process(self, delta)

func ladder_available(pos: Vector2) -> void:
	_current_state().ladder_available(self, pos)

func ladder_unavailable(_name: String) -> void:
	_current_state().ladder_unavailable(self)

func skill_card_available(skill: SkillCard) -> void:
	_current_state().skill_card_available(self, skill)

func skill_card_unavailable() -> void:
	_current_state().skill_card_unavailable(self)


func _update_animations(direction: float) -> void:
	var animation = _get_walking_animation(direction)

	if animation_player.current_animation == animation:
		return

	animation_player.play(animation)

	if direction < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false


func _get_walking_animation(direction: float) -> StringName:
	if direction == 0:
		return "idle"

	if direction < 0:
		return "move_left"

	return "move_right"
