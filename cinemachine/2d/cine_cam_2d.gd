class_name CineCam2D
extends Camera2D

var focus : VirtualCam2D
var current : bool
@export var smoothing := 0.7

func _ready():
	current = true
	focus = Cinemachine.vcam_highest()
	snap_focus()

func _process(_delta):
	if focus:
		global_position = global_position * smoothing + focus.global_position * (1 - smoothing)

func snap_focus():
	if focus:
		global_position = focus.global_position

func _enter_tree():
	Cinemachine.camera = self
