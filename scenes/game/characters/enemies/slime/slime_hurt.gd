extends EnemyState

func process(_delta):
	if enemy.hitstun <= 0:
		state_machine.transition_to("Wait")
