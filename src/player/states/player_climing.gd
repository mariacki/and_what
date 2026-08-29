class_name PlayerClimbing
extends PlayerBaseState

func physics_process(player: Player, _delta: float) -> void:
	player.global_position = player.global_position.move_toward(player.climb_dest, _delta * Player.SPEED)

	if player.global_position.distance_squared_to(player.climb_dest) <= 0.01:
		player.state_machine.switch_state(PlayerWalking, player)
