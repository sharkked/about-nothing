extends PlayerState

func init(_msg := {}) -> void:
	player.reset_on_land()

func physics_process(_delta: float) -> void:
	_poll_input()
	
	player.velocity.x = _move.x * player.RUN_SPD
	
	if _special:
		player.ball_toss()
	elif _jump:
		if _dash and player._air_dash_count < Game.data.player.air_dash_max:
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
	elif _move.y > 0:
			state_machine.transition_to("Crouch")
	elif _move.x == 0:
		state_machine.transition_to("Wait")
	elif not _move.x == 0:
		player.direction.x = sign(_move.x)
	
	_clear_input()
