extends Camera2D

var vcams : Array
@export var smoothing := 0.7

var last_active : VCamera2D

func _process(_delta):
	var vcam = get_highest_vcam()
	if vcam == null:
		return
	global_position = lerp(global_position, vcam.global_position, smoothing)

func snap_focus(vcam: VCamera2D):
	global_position = vcam.global_position

func vcam_create():
	var vcam = VCamera2D.new()
	vcam.name = "TEST ME"
	return vcam

func get_highest_vcam() -> VCamera2D:
	if vcams.is_empty():
		enabled = false
		return null
	enabled = true
	var highest = vcams[0]
	for vcam in vcams:
		if vcam.priority >= highest.priority:
			vcam = highest
	return highest

func set_limits(left: int, top: int, right: int, bottom: int):
	limit_left = left
	limit_top = top
	limit_right = right
	limit_bottom = bottom

### Signal recievers
func _on_vcam_priority_change(vcam: VCamera2D):
	snap_focus(vcam)

