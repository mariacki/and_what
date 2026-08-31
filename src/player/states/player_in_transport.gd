class_name PlayerInTransport
extends PlayerBaseState

func _enter(player: Player) -> void:
	player.visuals.set_animation(player.moving_animation)


func physics_process(player: Player, _delta: float) -> void:
	player.global_position = player.global_position.move_toward(player.move_destination, _delta * Player.SPEED)

	if player.global_position.distance_squared_to(player.move_destination) <= 0.01:
		player.state_machine.switch_state(PlayerWalking, player)
