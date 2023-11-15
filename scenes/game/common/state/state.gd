# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name State
extends Node

# reference the state machine for calling transition_to()
# phase this out if possible
var state_machine = null;

# virtual step in, msg contains init data
func enter(_msg := {}) -> void:
	pass

# virtual _unhandled_input() callback
func unhandled_input(_event: InputEvent) -> void:
	pass;

# virtual _process() callback
func process(_delta: float) -> void:
	pass;

# virtual _physics_process() callback
func physics_process(_delta: float) -> void:
	pass;

# virtual step out, use for cleanup
func exit() -> void:
	pass
