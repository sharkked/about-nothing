extends PlayerState

func init(_msg := {}) -> void:
	_poll_input()
	
	player.velocity.x = 1.2 * player.RUN_SPD * player.direction.x
	player.velocity.y = player.JUMP_SPD * 0.9
	player.snap = Vector2.ZERO
	player.gravity = player.JUMP_GRV

func physics_process(_delta: float) -> void:
	_poll_input()
	
	player.velocity.x = lerp(player.velocity.x, _move.x * player.RUN_SPD, 0.01)
	
	if _special:
		player.ball_toss()
	
	if _dash and player._air_dash_count < Game.data.player.air_dash_max:
		state_machine.transition_to("Airdash")
	elif player.is_on_floor():
		if _move.y > 0:
			state_machine.transition_to("Crouch")
		elif _move.x == 0:
			state_machine.transition_to("Wait")
		else:
			state_machine.transition_to("Run")
	elif player.velocity.y > 0 or not _jump_hold:
		if not _jump_hold:
			player.velocity.y = 0
		state_machine.transition_to("Air")
	
	_clear_input()

func exit(_msg := {}) -> void:
	if player.is_on_floor():
		player.snap = player.DEFAULT_SNAP
		player.gravity = player.FALL_GRV
