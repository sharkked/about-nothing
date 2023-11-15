class_name StateMachine
extends Node

# emitted on transition
signal state_changed(state_name)

# path to initial state
@export var initial_state := NodePath()
var is_active := true:
	set(value): set_is_active(value)

# current state
@onready var _state : State = get_node(initial_state)

# init
func _ready() -> void:
	# assign self to state.state_machine
	for child in get_children():
		child.state_machine = self
	_state.enter()

# delegate unhandled input callbacks
func _unhandled_input(event: InputEvent) -> void:
	_state.unhandled_input(event)

# delegate process callback
func _process(delta: float) -> void:
	_state.process(delta)

# delegate physics process callback
func _physics_process(delta: float) -> void:
	_state.physics_process(delta)

func get_state() -> StringName:
	return _state.name

# step out of curr state and into new state
func transition_to(target_state_path: String, msg: Dictionary = {}) -> void:
	# dont enter nonexistent states
	if not has_node(target_state_path):
		return
	
	_state.exit()
	self._state = get_node(target_state_path)
	_state.enter(msg)
	emit_signal("state_changed", _state.name)

# enable/disable state machine
func set_is_active(enable: bool):
	is_active = enable
	set_physics_process(enable)
	set_process_unhandled_input(enable)
	set_block_signals(not enable)

# emit state change signal
func _on_state_changed(_previous, new):
	print("state changed")
	emit_signal("state_changed", new)
