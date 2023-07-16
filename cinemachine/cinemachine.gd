extends Node

var v_cams : Array
var camera : CineCam2D

### Virtual camera helpers
func vcam_create():
	var v_cam = VirtualCam2D.new()
	v_cam.priority_changed.connect(_on_vcam_priority_change)
	return v_cam

func vcam_highest() -> VirtualCam2D:
	if v_cams.is_empty():
		return null
	var highest = v_cams[0]
	for v_cam in v_cams:
		if v_cam.priority >= highest.priority:
			v_cam = highest
	return highest

### Camera helpers
func camera_set_limits(left: int, top: int, right: int, bottom: int):
	if camera:
		camera.limit_left = left
		camera.limit_top = top
		camera.limit_right = right
		camera.limit_bottom = bottom

func camera_snap_focus():
	if camera:
		camera.snap_focus()

### Signal recievers
func _on_vcam_priority_change(v_cam: VirtualCam2D):
	print("hi")
	if v_cams.has(v_cam) and camera and (!camera.focus or v_cam.priority > camera.focus.priority):
		camera.focus = v_cam
