extends PlayerState

func init(_msg := { "jump_spd" : player.JUMP_SPD, "jump_grv" : player.JUMP_GRV }) -> void:
	_poll_input()
	
	player.velocity.y = player.JUMP_SPD
	player.gravity = player.JUMP_GRV
	player.snap = Vector2.ZERO
	
	if not player.is_on_floor():
		var vfx = player.air_jump_fx_resource.instantiate()
		vfx.global_position = player.global_position
		player.get_parent().add_child(vfx)
	
	SoundManager.play_se("jump")
	if not _move.x == 0:
		player.direction.x = sign(_move.x)

func physics_process(_delta: float) -> void:
	_poll_input()
	
	if _move.x:
		player.velocity.x = lerp(player.velocity.x, _move.x * player.RUN_SPD, 0.2)
	
	if _special:
		player.ball_toss()
	
	if _attack:
		state_machine.transition_to("AirLightN")
	elif _dash and player._air_dash_count < 1:
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
	player.snap = player.DEFAULT_SNAP
	player.gravity = player.FALL_GRV
