class_name PlayerWalking extends PlayerBaseState

func _exit(player: Player) -> void:
	player.can_climb = false
	player.arrow.visible = false
	player.visuals.set_animation(PlayerVisuals.ANIM_IDLE)
	player.skill_card_pickup = null

func physics_process(player: Player, _delta: float) -> void:
	if not player.is_on_floor():
		player.state_machine.switch_state(PlayerFalling, player)

		return

	player.apply_vertical_velocity()
	player.apply_gravity()
	player.move_and_slide()

	_handle_interactions(player)


func _handle_interactions(player: Player) -> void:
	arrow_reset(player)

	for interactive in player.detection_area.get_overlapping_areas():
		if interactive is SkillCard:
			_handle_skill_card(player, interactive)
			return

		if interactive is TransportPoint:
			_handle_transport_point(player, interactive)
			return

		if interactive is Edge:
			_handle_edge(player, interactive)
			return


func _handle_skill_card(player: Player, card: SkillCard) -> void:
	if not card.visible:
		return

	arrow_point_at(player, card.global_position)

	if not Input.is_action_just_pressed("action"):
		return

	if not _inventory_can_place_card(player, card):
		return

	_inventory_place_card(player, card)


func _handle_edge(player: Player, edge: Edge) -> void:
	if edge.jump_direction == Vector2.ZERO:
		return

	if not player.has_skill(SkillCard.Skill.JUMP):
		return

	arrow_show_jump(player, edge)

	if not Input.is_action_just_pressed("action"):
		return

	player.move_destination = player.global_position + edge.jump_direction * player.jump_length
	player.moving_animation = PlayerVisuals.ANIM_JUMP

	player.state_machine.switch_state(PlayerInTransport, player)

func _handle_transport_point(player: Player, transport_point: TransportPoint) -> void:
	if not player.has_skill(transport_point.required_skill):
		return

	arrow_point_at(player, transport_point.destination_point.global_position)

	if not Input.is_action_just_pressed("action"):
		return

	player.move_destination = transport_point.destination_point.global_position
	player.moving_animation = PlayerVisuals.ANIM_IDLE
	player.global_position.x = transport_point.destination_point.global_position.x

	player.state_machine.switch_state(PlayerInTransport, player)

func _inventory_can_place_card(player: Player, card: SkillCard) -> bool:
	if not card.visible:
		return false

	if card.requires == SkillCard.Skill.NOTHING:
		return true

	var last_skill = player.skills[player.skills.size() - 1]
	return last_skill.provides == card.requires

func _inventory_place_card(player: Player, card: SkillCard) -> void:
	if card.requires == SkillCard.Skill.NOTHING:
		for skill in player.skills:
			skill.show()

		player.skills = [card]
	else:
		player.skills.append(card)

	card.visible = false
	player.skills_updated.emit(player.skills)


func arrow_point_at(player: Player, position: Vector2) -> void:
	player.arrow.show()
	player.arrow.look_at(position)

func arrow_show_jump(player: Player, edge: Edge) -> void:
	player.arrow.show()
	player.arrow.position.x += edge.jump_direction.x * player.jump_length
	player.arrow.position.y -= Units.UNIT
	player.arrow.rotation_degrees = 90

func arrow_reset(player: Player) -> void:
	player.arrow.hide()
	player.arrow.position = Vector2.ZERO
	player.moving_animation = "idle"
