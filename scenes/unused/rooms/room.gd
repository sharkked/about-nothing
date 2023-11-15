class_name Room
extends Node2D

@export var entrances : Array[NodePath]

@onready var top_left := $CamLimits/TopLeft
@onready var bottom_right := $CamLimits/BottomRight

func _ready():
	CameraMan.set_limits(top_left.position.x, top_left.position.y, bottom_right.position.x, bottom_right.position.y)
