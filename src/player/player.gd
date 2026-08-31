class_name Player extends CharacterBody2D

signal skills_updated(skills: Array[SkillCard])

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var visuals: PlayerVisuals = %Visuals
@export var arrow: Node2D

@export var jump_length: float = 100

var state_machine: StateMachine = StateMachine.new()
var skills: Array[SkillCard] = []

var move_destination: Vector2 = Vector2.ZERO
var moving_animation: String = "idle"
var can_climb: bool = false

var skill_card_pickup: SkillCard = null

@onready var detection_area: DetectionArea = %DetectionArea

func _ready() -> void:
	z_index = Units.LAYER_PLAYER

	state_machine.register_state(PlayerWalking, PlayerWalking.new())
	state_machine.register_state(PlayerInTransport, PlayerInTransport.new())
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

func _physics_process(delta: float) -> void:
	_current_state().physics_process(self, delta)


func _update_animations(direction: float) -> void:
	visuals.moving(direction)


func _current_state() -> PlayerBaseState:
	return state_machine.current as PlayerBaseState


func has_skill(skill_id: SkillCard.Skill) -> bool:
	for skill in skills:
		if skill.provides == skill_id:
			return true

	return false
