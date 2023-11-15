extends EnemyState

var timer
var dir

func enter(_msg := {}):
	timer = randf_range(1, 3)
	dir = 1 - 2 * randi_range(0, 1)

func process(delta):
	timer -= delta
	enemy.velocity.x = 30 * dir
	if enemy.hitstop > 0:
		state_machine.transition_to("Hurt")
	elif timer <= 0:
		state_machine.transition_to("Wait")
