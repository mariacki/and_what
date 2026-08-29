class_name PlayerWalking extends PlayerBaseState

func _exit(player: Player) -> void:
	player.can_climb = false
	player.arrow.visible = false
	player.animation_player.play("idle")
	player.skill_card_pickup = null

func physics_process(player: Player, _delta: float) -> void:
	player.apply_vertical_velocity()
	player.apply_gravity()
	player.move_and_slide()

	player.arrow.hide()
	if _can_climb(player):
		player.arrow.show()
		player.arrow.look_at(player.climb_dest)
		if Input.is_action_just_pressed("action"):
			player.global_position.x = player.climb_dest.x
			player.state_machine.switch_state(PlayerClimbing, player)
			return

	if _can_pickup_card(player):
		player.arrow.show()
		player.arrow.look_at(player.skill_card_pickup.global_position)
		if Input.is_action_just_pressed("action"):
			_pickup_card(player)


	if not player.is_on_floor():
		player.state_machine.switch_state(PlayerFalling, player)

func ladder_available(player: Player, climb_dest: Vector2) -> void:
	player.can_climb = true
	player.climb_dest = climb_dest

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

	if player.skill_card_pickup.requires == "":
		return true

	var last_skill = player.skills[player.skills.size() - 1]

	return last_skill.provides == player.skill_card_pickup.requires

func _pickup_card(player: Player) -> void:
	if player.skill_card_pickup.requires == "":
		for skill in player.skills:
			skill.show()

		player.skills = [player.skill_card_pickup]
	else:
		player.skills.append(player.skill_card_pickup)

	player.skill_card_pickup.visible = false
	player.skill_card_pickup = null


func _can_climb(player: Player) -> bool:
	if not player.can_climb:
		return false

	for skill in player.skills:
		if skill.provides == "Ladder":
			return true

	return false
