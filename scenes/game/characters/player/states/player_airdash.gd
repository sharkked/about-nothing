extends PlayerState

var dash_timer: float

func init(_msg := {}) -> void:
	_poll_input()
	
	player._air_dash_count += 1
	
	player.velocity = Vector2.ZERO
	player.snap = Vector2.ZERO
	player.gravity = 0
	
	dash_timer = 0
	
	player.velocity = _move.normalized() * player.AIR_DASH_SPD
	
	if _move.y <= 0:
		player.velocity.y = 0
		if _move.x == 0:
			player.velocity.x = player.AIR_DASH_SPD * player.direction.x
		else:
			player.velocity.x = player.AIR_DASH_SPD * _move.x
	
	SoundManager.play_se("dash")

func physics_process(_delta: float) -> void:
	_poll_input()
	
	player.velocity = player.velocity * (1 - player.AIR_DASH_DECAY)
	
	if _jump and player._air_jump_count < 1:
		player._air_jump_count += 1
		state_machine.transition_to("Jump")
	elif player.is_on_floor():
		state_machine.transition_to("Waveland")
	elif dash_timer > player.AIR_DASH_TIME:
		state_machine.transition_to("Air")
	
	dash_timer += _delta
	
	_clear_input()

func exit(_msg := {}) -> void:
	if player.is_on_floor():
		player.snap = player.DEFAULT_SNAP
		player.gravity = player.FALL_GRV
		
