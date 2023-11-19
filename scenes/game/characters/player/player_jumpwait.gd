extends PlayerState

func init(_msg := {}) -> void:
	player.reset_on_land()

func physics_process(_delta: float) -> void:
	_poll_input()
	
	if _special:
		player.ball_toss()
	elif _jump:
		if _dash and player._air_dash_count < 1:#Game.data.player.air_dash_max:
			state_machine.transition_to("Airdash")
		else:
			state_machine.transition_to("Jump")
	elif _attack:
		if not _move.x == 0:
			state_machine.transition_to("HeavyF")
		else: 
			state_machine.transition_to("Jab1")
	elif not player.is_on_floor():
		state_machine.transition_to("Air")
	elif _attack:
		state_machine.transition_to("Jab1")
	elif _move.y > 0:
		state_machine.transition_to("Crouch")
	elif not _move.x == 0:
		player.direction.x = sign(_move.x)
		state_machine.transition_to("Run")
	
	_clear_input()
