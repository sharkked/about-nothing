@tool

class_name Room
extends Node2D

@export_group("Camera")
@export var left := 0
@export var top := 0
@export var right := 320
@export var bottom := 240

@export_group("Entrances")
@export var entrances: Array[NodePath]

func _process(_delta):
	if Engine.is_editor_hint():
		var bg_rect = $BG/ColorRect
		bg_rect.set_size(Vector2(right - left, bottom - top))
		queue_redraw()

func _draw():
	if Engine.is_editor_hint():
		draw_rect(Rect2i(left, top, right, bottom), Color(0.0, 1.0, 1.0, 0.5), false)
		pass

func _ready():
	if !Engine.is_editor_hint():
		CameraMan.set_limits(left, top, right, bottom)
