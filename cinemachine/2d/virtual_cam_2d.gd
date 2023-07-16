class_name VirtualCam2D
extends Node2D

signal priority_changed

@export var priority : int:
	get:
		return priority
	set(value):
		priority = value
		priority_changed.emit(self)

func _ready():
	priority_changed.connect(Cinemachine._on_vcam_priority_change)

func _enter_tree():
	Cinemachine.v_cams.append(self)
	priority_changed.emit(self)

func _exit_tree():
	Cinemachine.v_cams.erase(self)
