class_name PlayerAttackState
extends PlayerState

@export var looping : bool = false

func physics_process(_delta: float) -> void:
	_poll_input()
	
	player.velocity.x = lerp(player.velocity.x, 0.0, 0.8);

	if _jump and player.jump_cancel and player.hitstop <= 0:
		if _dash and player._air_dash_count < player.data.air_dash_max:
			state_machine.transition_to("Airdash")
		else:
			state_machine.transition_to("Jump")
	elif not player.is_on_floor():
		state_machine.transition_to("Air")
	elif _attack_hold and looping and player.cancel_state:
		player.get_node("AnimationPlayer").seek(0)
	elif player.exit_state:
		end_action()

	_clear_input()

func exit() -> void:
	player.reset_hitboxes()
