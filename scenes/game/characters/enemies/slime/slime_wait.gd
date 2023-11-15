extends EnemyState

var timer

func enter(_msg := {}):
	if enemy.animation:
		enemy.animation.play("Wait")
	timer = randf_range(5, 10)

func process(delta):
	timer -= delta
	if enemy.hitstop > 0:
		state_machine.transition_to("Hurt")
	elif timer <= 0:
		state_machine.transition_to("Move")
