class_name EnemyState
extends State

# reference to the enemy
var enemy : Enemy

func _ready() -> void:
	# wait for the "owner" to be ready
	var _enemy = owner;
	# casts "owner" variable to the "Enemy" type
	enemy = _enemy as Enemy
	# make sure non-"Enemy" nodes don't use "Enemy" states
	assert(enemy != null)

func enter(_msg := {}) -> void:
	enemy.animation.play(name)
	#enemy.exit_state = false
	#enemy.cancel_state = false
	#enemy.jump_cancel = false
	init(_msg)
	
func init(_msg := {}) -> void:
	pass

func end_action():
	#if enemy.is_on_floor():
		state_machine.transition_to("Wait")
	#else:
		#state_machine.transition_to("Air")
