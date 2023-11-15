extends PlayerState

func init(_msg := {}):
	player.reset_on_land()
	player.stop_on_slope = true

func physics_process(_delta: float):
	_poll_input()
	
	player.velocity.x = lerp(player.velocity.x, 0.0, 0.09)
	
	_poll_input()
	
	if _jump:
		state_machine.transition_to("Jump")
	elif player.exit_state:
		end_action()
		if state_machine.get_state() == "Crouch":
			player.animation.seek(1)

	_clear_input()

func exit(_msg := {}):
	if player.is_on_floor():
		player.snap = player.DEFAULT_SNAP
		player.gravity = player.FALL_GRV
