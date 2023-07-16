extends PlayerState

func init(_msg := {}) -> void:
	player.reset_on_land()

func physics_process(_delta: float) -> void:
	_poll_input()
	
	player.velocity.x = lerp(player.velocity.x, 0.0, 0.2)
	
	if _special:
		# ball_roll
		pass
	if _jump:
		if _dash and player._air_dash_count < Game.data.player.air_dash_max:
			state_machine.transition_to("Airdash")
		else:
			state_machine.transition_to("Jump")
	elif not player.is_on_floor():
		state_machine.transition_to("Air")
	elif _attack:
		state_machine.transition_to("LightD")
	elif _move.y <= 0:
		if _move == Vector2.ZERO:
			state_machine.transition_to("Wait")
		else:
			state_machine.transition_to("Run")
	
	_clear_input()
