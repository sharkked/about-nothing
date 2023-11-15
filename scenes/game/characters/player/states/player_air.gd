extends PlayerState

func init(_msg := {}) -> void:
	player.snap = Vector2.ZERO
	player.gravity = player.FALL_GRV

func physics_process(_delta: float) -> void:
	_poll_input()
	
	if _move.x:
		player.velocity.x = lerp(player.velocity.x, _move.x * player.RUN_SPD, 0.2);
	
	if _special:
		player.ball_toss()
		
	if _attack:
		state_machine.transition_to("AirLightN")
	elif not _move.x == 0 and player.is_on_wall():
		state_machine.transition_to("Wallslide")
	elif _dash and player._air_dash_count < 1:
		state_machine.transition_to("Airdash")
	elif _jump and player._air_jump_count < 1:
		player._air_jump_count += 1
		state_machine.transition_to("Jump")
	elif player.is_on_floor():
		if _move.y > 0:
			state_machine.transition_to("Crouch")
		elif _move.x == 0:
			state_machine.transition_to("Wait")
		else:
			state_machine.transition_to("Run")
	
	_clear_input()

func exit(_msg := {}) -> void:
	if player.is_on_floor():
		player.snap = player.DEFAULT_SNAP
		player.gravity = player.FALL_GRV
