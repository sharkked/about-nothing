extends PlayerState

func init(_msg := {}) -> void:
	_poll_input()
	
	player.velocity.y = 0
	player.gravity = 0
	
	if not _move.x == 0:
		player.direction.x = -_move.x

func physics_process(_delta: float) -> void:
	_poll_input()
	
	player.velocity.x = _move.x * player.RUN_SPD;
	if _move.y > 0:
		player.gravity = 0.25 * player.FALL_GRV 
	else:
		player.gravity = 0
		player.velocity.y = 0
	
	if _jump:
		state_machine.transition_to("Walljump")
	elif player.is_on_floor():
		if _move.y > 0:
			state_machine.transition_to("Crouch")
		elif _move.x == 0:
			state_machine.transition_to("Wait")
		else:
			state_machine.transition_to("Run")
	elif _move.x == 0 or not player.is_on_wall():
		if not _jump_hold:
			player.velocity.y = 0
		state_machine.transition_to("Air")
	
	_clear_input()

func exit(_msg := {}) -> void:
	if player.is_on_floor():
		player.snap = player.DEFAULT_SNAP
		player.gravity = player.FALL_GRV
