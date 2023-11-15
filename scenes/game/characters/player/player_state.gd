class_name PlayerState
extends State

# reference to the player
var player : Player

# input polling
var _move := Vector2.ZERO
var _jump_hold : bool = false
var _act_hold : bool = false
var _attack_hold : bool = false
var _special_hold : bool = false
var _dash_hold : bool = false

# event inputs
var _jump : bool = false
var _act : bool = false
var _attack : bool = false
var _special : bool = false
var _dash : bool = false

func _ready() -> void:
	# wait for the "owner" to be ready
	var _player = owner;
	# casts "owner" variable to the "Player" type
	player = _player as Player
	# make sure non-"Player" nodes don't use "Player" states
	assert(player != null)

func enter(_msg := {}) -> void:
	player.get_node("AnimationPlayer").play(name)
	player.exit_state = false
	player.cancel_state = false
	player.jump_cancel = false
	init(_msg)
	
func init(_msg := {}) -> void:
	pass

func unhandled_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		_jump = true
	if _event.is_action_pressed("act"):
		_act = true
	if _event.is_action_pressed("attack"):
		_attack = true
	if _event.is_action_pressed("special"):
		_special = true
	if _event.is_action_pressed("dash"):
		_dash = true

func _poll_input() -> void:
	var move_right = Input.is_action_pressed("move_right")
	var move_left = Input.is_action_pressed("move_left")
	var move_up = Input.is_action_pressed("move_up")
	var move_down = Input.is_action_pressed("move_down")
	
	_move = Vector2(float(move_right) - float(move_left), float(move_down) - float(move_up))
	
	_jump_hold = Input.is_action_pressed("jump")
	_act_hold = Input.is_action_pressed("attack")
	_attack_hold = Input.is_action_pressed("attack")
	_special_hold = Input.is_action_pressed("special")
	_dash_hold = Input.is_action_pressed("dash")

func _clear_input() -> void:
	_move = Vector2.ZERO;
	
	_jump_hold = false
	_act_hold = false
	_attack_hold = false
	_special_hold = false
	_dash_hold = false
	
	_jump = false
	_act = false
	_attack = false
	_special = false
	_dash = false

func end_action():
	if player.is_on_floor():
		if _move.y > 0:
			state_machine.transition_to("Crouch")
		elif _move.x == 0:
			state_machine.transition_to("Wait")
		else:
			state_machine.transition_to("Run")
	else:
		state_machine.transition_to("Air")
