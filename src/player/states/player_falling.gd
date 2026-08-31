class_name PlayerFalling
extends PlayerBaseState

func _enter(player: Player) -> void:
	player.visuals.set_animation(PlayerVisuals.ANIM_IDLE)


func physics_process(player: Player, _delta: float) -> void:
	player.velocity.x = 0
	player.apply_gravity()
	player.move_and_slide()

	if player.is_on_floor():
		player.state_machine.switch_state(PlayerWalking, player)
