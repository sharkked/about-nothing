extends PlayerState

@export var looping : bool = false

func init(_msg := {}) -> void:
	player.gravity = player.JUMP_GRV

func physics_process(_delta: float) -> void:
	_poll_input()
	
	if _move.x:
		player.velocity.x = lerp(player.velocity.x, _move.x * player.RUN_SPD, 0.1);

	if _jump and player._air_jump_count < 1 and player.jump_cancel and player.hitstop <= 0:
		state_machine.transition_to("Jump")
	elif player.is_on_floor():
		end_action()
	elif _attack_hold and looping and player.cancel_state:
		player.animation.seek(0)
	elif player.exit_state:
		end_action()

	_clear_input()

func exit() -> void:
	player.reset_hitboxes()
