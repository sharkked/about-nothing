class_name VCamera2D
extends Node2D

signal priority_changed

@export var priority : int:
	get:
		return priority
	set(value):
		priority = value
		priority_changed.emit(self)

func _ready():
	priority_changed.connect(CameraMan._on_vcam_priority_change)

func _enter_tree():
	CameraMan.vcams.append(self)
	priority_changed.emit(self)

func _exit_tree():
	CameraMan.vcams.erase(self)
