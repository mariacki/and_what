class_name PlayerWalking extends PlayerBaseState

func _exit(player: Player) -> void:
	player.can_climb = false
	player.arrow.visible = false
	player.animation_player.play("idle")
	player.skill_card_pickup = null

func physics_process(player: Player, _delta: float) -> void:
	if not player.is_on_floor():
		player.state_machine.switch_state(PlayerFalling, player)

		return

	player.apply_vertical_velocity()
	player.apply_gravity()
	player.move_and_slide()

	player.arrow.hide()
	player.arrow.position = Vector2.ZERO
	player.moving_animation = "idle"

	if _can_climb(player):
		player.arrow.show()
		player.arrow.look_at(player.move_dest)
		if Input.is_action_just_pressed("action"):
			player.global_position.x = player.move_dest.x
			player.state_machine.switch_state(PlayerClimbing, player)
			return

	if _can_pickup_card(player):
		player.arrow.show()
		player.arrow.look_at(player.skill_card_pickup.global_position)
		if Input.is_action_just_pressed("action"):
			_pickup_card(player)
			return

	var edge = player.detection_area.edge_find_first()
	if edge and edge.jump_direction != Vector2.ZERO and _has_jump_skill(player):
		player.arrow.show()
		player.arrow.position.x += edge.jump_direction.x * player.jump_length
		player.arrow.position.y -= Units.UNIT
		player.arrow.rotation_degrees = 90

		if Input.is_action_just_released("action"):
			player.move_dest = player.global_position + edge.jump_direction * player.jump_length
			player.moving_animation = "jump"
			player.state_machine.switch_state(PlayerClimbing, player)

			return


func _has_jump_skill(player: Player) -> bool:
	for skill in player.skills:
		if skill.provides == SkillCard.Skill.JUMP:
			return true

	return false

func ladder_available(player: Player, climb_dest: Vector2) -> void:
	player.can_climb = true
	player.move_dest = climb_dest

func ladder_unavailable(player: Player) -> void:
	player.can_climb = false

func skill_card_available(player: Player, skill_card: SkillCard) -> void:
	player.skill_card_pickup = skill_card

func skill_card_unavailable(player: Player) -> void:
	player.skill_card_pickup = null

	player.arrow.visible = false

func _can_pickup_card(player: Player) -> bool:
	if not player.skill_card_pickup:
		return false

	if not player.skill_card_pickup.visible:
		return false

	if player.skills.is_empty():
		return true

	if player.skill_card_pickup.requires == SkillCard.Skill.NOTHING:
		return true

	var last_skill = player.skills[player.skills.size() - 1]

	return last_skill.provides == player.skill_card_pickup.requires

func _pickup_card(player: Player) -> void:
	if player.skill_card_pickup.requires == SkillCard.Skill.NOTHING:
		for skill in player.skills:
			skill.show()

		player.skills = [player.skill_card_pickup]
	else:
		player.skills.append(player.skill_card_pickup)

	player.skill_card_pickup.visible = false
	player.skill_card_pickup = null
	player.skills_updated.emit(player.skills)


func _can_climb(player: Player) -> bool:
	if not player.can_climb:
		return false

	for skill in player.skills:
		if skill.provides == SkillCard.Skill.LADDER:
			return true

	return false
