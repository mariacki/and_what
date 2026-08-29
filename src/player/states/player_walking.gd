class_name PlayerWalking extends PlayerBaseState

func _exit(player: Player) -> void:
	player.arrow.visible = false
	player.animation_player.play("idle")

func physics_process(player: Player, _delta: float) -> void:
	player.apply_vertical_velocity()
	player.apply_gravity()
	player.move_and_slide()

	if player.can_climb:
		player.arrow.look_at(player.climb_dest)
		if Input.is_action_just_pressed("action"):
			player.global_position.x = player.climb_dest.x
			player.state_machine.switch_state(PlayerClimbing, player)
			return
	else:
		player.arrow.visible = false

	if not player.is_on_floor():
		player.state_machine.switch_state(PlayerFalling, player)

func ladder_available(player: Player, climb_dest: Vector2) -> void:
	player.can_climb = true
	player.climb_dest = climb_dest
	player.arrow.visible = true
	player.arrow.look_at(player.climb_dest)

func ladder_unavailable(player: Player) -> void:
	player.can_climb = false
	player.arrow.visible = false
